---@diagnostic disable-next-line: undefined-doc-name
---@type LazyPluginSpec
return {
  "HakonHarnes/img-clip.nvim",
  cmd = {
    "PasteImage",
  },
  opts = {
    filetypes = {
      tex = {
        relative_template_path = false, ---@type boolean
        template = [[
\begin{figure}[H]
  \centering
  \includegraphics[width=0.6\textwidth]{$FILE_PATH}
  \caption{$CURSOR}
  \label{fig:$LABEL}
\end{figure}
    ]], ---@type string
      }
    }
  },
}
