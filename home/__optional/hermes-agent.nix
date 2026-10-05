{
  config,
  inputs,
  osConfig,
  ...
}:
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    workingDirectory = "${config.home.homeDirectory}/projects";
    settings = {
      model = {
        provider = "deepseek";
        default = "deepseek-flash";
      };
    };

    mcpServers = {
      "PaddleOCR-VL-1.6" = {
        command = "uvx";
        args = [
          "--from"
          "paddleocr-mcp"
          "paddleocr_mcp"
        ];
        env = {
          PADDLEOCR_MCP_MODEL = "PaddleOCR-VL-1.6";
          PADDLEOCR_MCP_PPOCR_SOURCE = "aistudio";
          PADDLEOCR_MCP_AISTUDIO_ACCESS_TOKEN = "\${PADDLEOCR_MCP_AISTUDIO_ACCESS_TOKEN}";
        };
      };
    };

    # sops-nix is configured by the host, not Home Manager.
    environmentFiles = [ osConfig.sops.secrets."hermes-agent-env".path ];
  };
}
