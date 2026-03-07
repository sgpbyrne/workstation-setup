{ pkgs, ... }:

let
  # Helm wrapped with plugins
  my-helm = pkgs.wrapHelm pkgs.kubernetes-helm {
    plugins = with pkgs.kubernetes-helmPlugins; [
      helm-secrets
      helm-diff
      helm-s3
      helm-git
    ];
  };
in
{
  home.packages = with pkgs; [
    # Kubernetes
    kubectl
    kubectx
    stern
    kubectl-neat
    krew
    kind
    kubelogin

    # Helm (wrapped with plugins)
    my-helm
    helm-docs

    # Terraform / OpenTofu
    tenv
    tflint
    trivy

    # GitOps
    argocd

    # Go development tools
    golangci-lint
    go-task

    # Container tools
    docker-compose
    dive
    crane

    # Kubernetes manifest tools
    kustomize
    kubeconform

    # Secrets
    sops

    # Colorized kubectl output
    kubecolor
  ];

  # Alias kubectl to kubecolor
  programs.zsh.shellAliases = {
    kubectl = "kubecolor";
  };
}
