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
      skills = {
        create_dir = "${config.home.homeDirectory}/projects/skills/hermes-agent-learned";
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
      "basic_ent_tools" = {
        url = "https://datamcp.qibook.com/mcp/qibook-basic";
        headers = {
          access_key = "\${QIBOOK_ACCESS_KEY}";
        };
      };
      "operate_ent_tools" = {
        url = "https://datamcp.qibook.com/mcp/qibook-operate";
        headers = {
          access_key = "\${QIBOOK_ACCESS_KEY}";
        };
      };
      "relation_ent_tools" = {
        url = "https://datamcp.qibook.com/mcp/qibook-relation";
        headers = {
          access_key = "\${QIBOOK_ACCESS_KEY}";
        };
      };
      "risk_ent_tools" = {
        url = "https://datamcp.qibook.com/mcp/qibook-risk";
        headers = {
          access_key = "\${QIBOOK_ACCESS_KEY}";
        };
      };
    };

    # sops-nix is configured by the host, not Home Manager.
    environmentFiles = [ osConfig.sops.secrets."hermes-agent-env".path ];
  };
}
