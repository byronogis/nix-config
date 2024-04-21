{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-configtool
        fcitx5-gtk
        # kdePackages.fcitx5-qt

        fcitx5-chinese-addons
      ];
      settings = {
        # xdg/fcitx5/profile
        # inputMethod = {};
        # xdg/fcitx5/conf/pinyin.conf
        addons = {
          pinyin.globalSection.ShuangpinProfile = "Xiaohe";
        };
      };
    };
  };
}
