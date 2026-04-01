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
      if ! az account get-access-token &>/dev/null; then
        echo "Not logged into Azure (or token expired). Launching az login..."
        az login || return 1
      fi
      mkdir -p "${kubeDir}"
      ${lib.concatMapStrings (c:
        let context = c.context or c.name;
        in ''
      echo "Fetching credentials for ${c.name}..."
      if az aks get-credentials \
        --resource-group ${c.resourceGroup} \
        --name ${c.name} \
        ${lib.optionalString (c ? subscription) "--subscription ${c.subscription} \\"}
        --file "${kubeDir}/${context}" \
        --overwrite-existing; then
        kubelogin convert-kubeconfig -l azurecli --kubeconfig "${kubeDir}/${context}"
        kubectl config rename-context "${c.name}" "${context}" --kubeconfig "${kubeDir}/${context}" 2>/dev/null || true
      else
        echo "Failed to fetch credentials for ${c.name}"
      fi
      '') clusters}
      echo "Done! Use 'kubectx' to switch between clusters."
    }
  '';
}
