return {
  {
    "nosduco/remote-sshfs.nvim",

    dependencies = {
      "nvim-telescope/telescope.nvim",
    },

    cmd = {
      "RemoteSSHFSConnect",
      "RemoteSSHFSDisconnect",
      "RemoteSSHFSReload",
    },

    opts = {},
  },
}
