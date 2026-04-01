{ lib, clusters, ... }:

let
  hasClusters = clusters != [];
  kubeDir = "$HOME/.kube/configs";
  kubeConfigPaths = lib.concatStringsSep ":" (
    (map (c: "${kubeDir}/${c.context or c.name}") clusters) ++ [ "$HOME/.kube/config" ]
  );
in
lib.mkIf hasClusters {
  programs.zsh.sessionVariables.KUBECONFIG = kubeConfigPaths;

  programs.zsh.initContent = ''
    kube-init() {
      if ! az account show &>/dev/null; then
        echo "Not logged into Azure. Run 'az login' first."
        return 1
      fi
      mkdir -p "${kubeDir}"
      ${lib.concatMapStrings (c:
        let context = c.context or c.name;
        in ''
      echo "Fetching credentials for ${c.name}..."
      az aks get-credentials \
        --resource-group ${c.resourceGroup} \
        --name ${c.name} \
        ${lib.optionalString (c ? subscription) "--subscription ${c.subscription} \\"}
        --file "${kubeDir}/${context}" \
        --overwrite-existing
      kubelogin convert-kubeconfig -l azurecli --kubeconfig "${kubeDir}/${context}"
      kubectl config rename-context "${c.name}" "${context}" --kubeconfig "${kubeDir}/${context}" 2>/dev/null || true
      '') clusters}
      echo "Done! Use 'kubectx' to switch between clusters."
    }
  '';
}
