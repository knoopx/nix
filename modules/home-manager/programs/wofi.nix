{...}: {
  stylix.targets.wofi.enable = false;

  programs.wofi = {
    enable = true;
    style = ''
      #window {
        font-size: 13px;
      }
      #window #outer-box #input {
        border: none;
        outline: none;
        padding: 0.6rem 1rem;
        border-radius: 0;
      }
      #window #outer-box #input:focus, #window #outer-box #input:focus-visible, #window #outer-box #input:active {
        border: none;
        outline: none;
      }
      #window #outer-box #scroll #inner-box #entry {
        padding: 0.6rem 1rem;
      }
      #window #outer-box #scroll #inner-box #entry #img {
        width: 1rem;
        margin-right: 0.5rem;
      }
      #window #outer-box #scroll #inner-box #entry:selected {
        border: none;
        outline: none;
      }
    '';
  };
}
