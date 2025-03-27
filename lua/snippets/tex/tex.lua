local in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end


-- local first = '┌' .. string.rep('─', #text + 2) .. '┐'
-- local middle = '│ ' .. text .. ' │'
-- local last = '└' .. string.rep('─', #text + 2) .. '┘'

local sign = s(
  { trig = "sign", dsrc = "Signature" },
  fmta([[
  Yours sincerely,

  Abdullah Danish
  ]], {})
)

local box = s(
  { trig = "box", dsrc = "surround by box" },
  fmta([[
  ┌<top>┐
  │ <middle> │
  └<bottom>┘
  <after>
  ]], {
    middle = i(1),
    top = f(function(args, _) return string.rep('─', #args[1][1] + 2) end, { 1 }),
    bottom = f(function(args, _) return string.rep('─', #args[1][1] + 2) end, { 1 }),
    after = i(0),
  })
)

local beg = s(
  {
    trig = "beg",
    dsrc = "beginning of a LaTeX document",
    snippetType = "autosnippet"
  },
  fmta(
    [[
    \begin{<name>}
      <ends>
    \end{<namef>}
    ]],
    {
      name = i(1),
      namef = f(text_same_with, 1),
      ends = i(0),
    }
  ),
  { condition = conds.line_begin }
)

local mk = s(
  {
    trig = "mk",
    dsrc = "inline math",
    snippetType = "autosnippet"
  },
  fmta(
    [[
    $<content>$<after>
    ]],
    {
      content = i(1),
      after = i(0)
    }
  )
)

local dm = s(
  {
    trig = "dm",
    dsrc = "display math",
    snippetType = "autosnippet"
  },
  fmta([[
    \[
    <content>
    \] <after>
  ]], {
    content = i(1),
    after = i(0)
  })
)

local to_subscript = function(_, snip)
  local s = snip.captures
  return string.format("%s_{%d}", s[1], s[2])
end

local sub1 = s(
  {
    trig = "([A-Za-z])(%d)",
    dsrc = "subscript - type 1",
    regTrig = true,
    snippetType = "autosnippet",
    condition = in_mathzone
  },
  f(to_subscript)
)

local sub2 = s(
  {
    trig = "([A-Za-z])_(%d%d)",
    dsrc = "subscript - type 2",
    regTrig = true,
    snippetType = "autosnippet",
    condition = in_mathzone
  },
  f(to_subscript)
)

local sub3 = s(
  {
    trig = "([A-Za-z])([ij]) ",
    dsrc = "subscript - type 3",
    regTrig = true,
    wordTrig = false,
    snippetType = "autosnippet",
    condition = in_mathzone
  },
  f(function(_, snip)
    return string.format("%s_%s ", snip.captures[1], snip.captures[2])
  end)
)

-- local sub4 = s (
--   {
--     trig = "([A-Za-z])_([ij])",
--     dsrc = "subscript - type 3",
--     regTrig = true,
--     wordTrig = false,
--     snippetType = "autosnippet",
--     condition = in_mathzone
--   },
--   f(function(_, snip)
--     return string.format("%s_{%s}", snip.captures[1], snip.captures[2])
--   end)
-- )

local sr = s(
  { trig = "sr", dsrc = "square", wordTrig = false, snippetType = "autosnippet" },
  t("^2"),
  { condition = in_mathzone }
)

local cb = s(
  { trig = "cb", dsrc = "cube", wordTrig = false, snippetType = "autosnippet" },
  t("^3"),
  { condition = in_mathzone }
)

local sqrt = s(
  { trig = "sq", dsrc = "square root", wordTrig = false, snippetType = "autosnippet" },
  fmta([[
  \sqrt{<content>}<after>
  ]], { content = d(1, insert_copy_from_clipboard), after = i(0) }),
  { condition = in_mathzone }
)

local compl = s(
  { trig = "compl", dsrc = "complement", wordTrig = false, snippetType = "autosnippet" },
  t("^{c}"),
  { condition = in_mathzone }
)

local td = s(
  { trig = "td", dsrc = "superscript", wordTrig = false, snippetType = "autosnippet", },
  fmta([[^{<power>}<after>]], { power = i(1), after = i(0) }),
  { condition = in_mathzone }
)

local us = s(
  { trig = "us", dsrc = "underscript", wordTrig = false, snippetType = "autosnippet", },
  fmta([[_{<power>}<after>]], { power = i(1), after = i(0) }),
  { condition = in_mathzone }
)

local frac1 = s(
  { trig = "//", dsrc = "fraction - type 1", wordTrig = false, snippetType = "autosnippet", condition = in_mathzone },
  fmta([[
  \frac{<num>}{<den>}
  ]], {
    num = i(1),
    den = i(2),
  })
)

local frac2 = s(
  {
    trig = [[((\d+)|(\d*)(\\)?([A-Za-z]+)((\^|_)(\{\d+\}|\d))*)/]],
    dsrc = "fraction - type 2",
    wordTrig = false,
    snippetType =
    "autosnippet",
    trigEngine = "ecma",
    condition = in_mathzone
  },
  fmta([[
  \frac{<num>}{<den>}<after>
  ]], {
    num = f(function(_, snip) return snip.captures[1] end),
    den = i(1),
    after = i(0),
  })
)

local frac3 = s(
  {
    trig = "^(.*%))/",
    dsrc = "() fraction",
    regTrig = true,
    wordTrig = false,
    snippetType = "autosnippet",
    condition =
        in_mathzone
  },
  fmta([[
  <num>{<den>}<after>
  ]], {
    num = f(function(_, snip)
      local text = snip.captures[1]
      local stripped = text:sub(1, #text)
      local depth = 0
      local i = #stripped
      while true do
        if stripped:sub(i, i) == ")" then
          depth = depth + 1
        elseif stripped:sub(i, i) == "(" then
          depth = depth - 1
        end
        if depth == 0 or i < 1 then
          break
        end
        i = i - 1
      end
      return stripped:sub(1, i - 1) .. "\\frac{" .. stripped:sub(i + 1, #stripped - 1) .. "}"
    end),
    den = i(1),
    after = i(0),
  })
)

local sympy1 = s( -- This snippets creates the sympy block ;)
  { trig = "sympy", desc = "Creates a sympy block", snippetType = "autosnippet" },
  fmt("sympy {} sympy{}",
    { i(1), i(0) }
  )
)

local sympy2 = s( -- This one evaluates anything inside the simpy block
  { trig = "sympy.*sympy ", wordTrig = false, regTrig = true, desc = "Sympy block evaluator", snippetType = "autosnippet", priority = 10000 },
  d(1, function(_, parent)
    -- Gets the part of the block we actually want, and replaces spaces
    -- at the beginning and at the end
    local to_eval = string.gsub(parent.trigger, "^sympy(.*)sympy", "%1")
    to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")

    local Job = require("plenary.job")

    local sympy_script = string.format(
      [[
from sympy import *
from sympy.parsing.sympy_parser import parse_expr
from sympy.printing.latex import print_latex
parsed = parse_expr('%s')
print_latex(parsed)
            ]],
      to_eval
    )

    sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
    local result = ""

    Job:new({
      command = "python",
      args = {
        "-c",
        sympy_script,
      },
      on_exit = function(j)
        result = j:result()
      end,
    }):sync()

    return sn(nil, t(result))
  end)
)

-- postfix snippets
local bar1 = s(
  { trig = "bar", dsrc = "bar", snippetType = "autosnippet", priority = 10, condition = in_mathzone },
  fmta([[
  \bar{<content>}<after>
  ]], { content = i(1), after = i(0) })
)

local bar2 = s(
  {
    trig = "([a-zA-Z])bar",
    dsrc = "bar with letter",
    regTrig = true,
    snippetType = "autosnippet",
    priority = 100,
    condition =
        in_mathzone
  },
  fmta([[
  \overline{<content>}<after>
  ]], { content = f(function(_, snip) return snip.captures[1] end), after = i(0) })
)


local hat1 = s(
  { trig = "hat", dsrc = "hat", snippetType = "autosnippet", priority = 10, condition = in_mathzone, wordTrig = false },
  fmta([[
  \hat{<content>}<after>
  ]], { content = i(1), after = i(0) })
)

local hat2 = s(
  {
    trig = "([a-zA-Z])hat",
    dsrc = "hat with letter",
    regTrig = true,
    snippetType = "autosnippet",
    priority = 100,
    condition =
        in_mathzone
  },
  fmta([[
  \hat{<content>}<after>
  ]], { content = f(function(_, snip) return snip.captures[1] end), after = i(0) })
)

local vec = s(
  {
    trig = [[(\\?\w+)(,\.|\.,)]],
    dsrc = "vector",
    trigEngine = "ecma",
    snippetType = "autosnippet",
    condition =
        in_mathzone
  },
  fmta([[
  \vec{<content>}<after>
  ]], { content = f(function(_, snip) return snip.captures[1] end), after = i(0) })
)

-- local eqn = s(
--   { trig = "eqn", dsrc = "equation", snippetType = "autosnippet" },
--   fmta([[
--   \begin{<type>
--     <content>
--   \end{<type_copy>
--   <after>
--   ]], {
--     type = c(1,
--       { t("equation*}"),
--         sn(nil, { t("equation}"),
--           c(1, { t(""), sn(nil, {
--             t({ "", "  " }), t("\\label{eq:"), i(1), t("}")
--         }) }) }), }),
--     content = i(2),
--     type_copy = f(text_same_with, 1),
--     after = i(0)
--   })
-- )

local eqn = s(
  { trig = "eqn", dsrc = "equation", snippetType = "autosnippet" },
  fmta([[
  \begin{<type>}
    <content>
  \end{<type_copy>}<after>
  ]], {
    type = c(1, { t("equation"), t("equation*") }),
    content = c(2, { d(nil, function(args, _)
      if args[1][1] == "equation" then
        return sn(1, c(1, { sn(nil, { t("\\label{eq:"), i(1), t({ "}", "  " }), i(2) }), sn(nil, i(1)) }))
      else
        return sn(1, i(1))
      end
    end, { 1 }) }),
    type_copy = f(text_same_with, 1),
    after = i(0)
  })
)

local last_num = function(args)
  local equation = args[1][1]
  local num = string.find(equation, "(%d+)$")
  if num then
    return string.sub(equation, num)
  else
    return "1"
  end
end

local rec_ali
rec_ali = function()
  return sn(
    nil,
    { c(1, { t(""), t(" \\nonumber"), sn(nil, { t(" \\label{eq:"), i(1), t("} "), t("\\tag{"), f(last_num, 1), t("}") }) }),
      c(2, {
        -- Order is important, sn(...) first would cause infinite loop of expansion.
        t(""),
        sn(nil, { t({ " \\\\", "  & " }), i(1), d(2, rec_ali, {}) }),
      }) }
  )
end

local align1 = s(
  { trig = "aln ", dsrc = "align - type 1", snippetType = "autosnippet" },
  fmta([[
  \begin{align}
    & <content><continue>
  \end{align}<after>
  ]], {
    content = i(1),
    continue = d(2, rec_ali, {}),
    after = i(0)
  })
)

local rec_ali2
rec_ali2 = function()
  return sn(
    nil,
    { c(1, {
      t(""),
      sn(nil, { t({ " \\\\", "  " }), i(1), d(2, rec_ali2, {}) }),
    }) }
  )
end

local align2 = s(
  { trig = "aln* ", dsrc = "align - type 2", snippetType = "autosnippet" },
  fmta([[
  \begin{align*}
    <content><continue>
  \end{align*}<after>
  ]], {
    content = i(1),
    continue = d(2, rec_ali2, {}),
    after = i(0)
  })
)

local gen_matrix = function(row, col)
  local tbl = {}
  for m = 1, row do
    for n = 1, col do
      table.insert(tbl, i((m - 1) * col + n))
      if n ~= col then
        table.insert(tbl, t(" & "))
      end
    end
    if m ~= row then
      table.insert(tbl, t({ " \\\\", "  " }))
    end
  end
  table.insert(tbl, t(""))
  return sn(nil, tbl)
end


local matrix1 = s(
  { trig = "mat(%d)(%d)", dsrc = "matrix - type 1", snippetType = "autosnippet", regTrig = true, condition = in_mathzone },
  fmta([[
  \begin{bmatrix} <content> \end{bmatrix}<after>
  ]], {
    content = d(1, function(_, snip) return gen_matrix(tonumber(snip.captures[1]), tonumber(snip.captures[2])) end, {}),
    after = i(0)
  })
)

local matrix2 = s(
  { trig = "mat ", dsrc = "matrix - type 2", snippetType = "autosnippet", condition = in_mathzone },
  fmta([[
  \begin{bmatrix} <content> \end{bmatrix}<after>
  ]], {
    content = i(1),
    after = i(0)
  })
)

local augmented_matrix1 = s(
  { trig = "amat(%d)(%d)", dsrc = "matrix - type 1", snippetType = "autosnippet", regTrig = true, condition = in_mathzone },
  fmta([[
  \left[ \begin{array}{<shape1>|<shape2>} <content> \end{array} \right]<after>
  ]], {
    shape1 = i(1),
    shape2 = i(2),
    content = d(3, function(_, snip) return gen_matrix(tonumber(snip.captures[1]), tonumber(snip.captures[2])) end, {}),
    after = i(0)
  })
)

local augmented_matrix2 = s(
  { trig = "amat ", dsrc = "matrix - type 2", snippetType = "autosnippet", condition = in_mathzone },
  fmta([[
  \left[ \begin{array}{<shape1>|<shape2>} <content> \end{array} \right]<after>
  ]], {
    shape1 = i(1),
    shape2 = i(2),
    content = i(3),
    after = i(0)
  })
)

local gen_vector = function(dim, sign)
  local tbl = {}
  for n = 1, dim do
    table.insert(tbl, i(n))
    if n ~= dim then
      table.insert(tbl, t(" " .. sign .. " "))
    end
  end
  table.insert(tbl, t(""))
  return sn(nil, tbl)
end

local row_vector = s(
  { trig = "rvec(%d)", dsrc = "row vector", snippetType = "autosnippet", regTrig = true, condition = in_mathzone },
  fmta([[
  \begin{bmatrix} <content> \end{bmatrix}<after>
  ]], {
    content = d(1, function(_, snip) return gen_vector(tonumber(snip.captures[1]), "&") end, {}),
    after = i(0)
  })
)

local col_vector = s(
  { trig = "cvec(%d)", dsrc = "column vector", snippetType = "autosnippet", regTrig = true, condition = in_mathzone },
  fmta([[
  \begin{bmatrix} <content> \end{bmatrix}<after>
  ]], {
    content = d(1, function(_, snip) return gen_vector(tonumber(snip.captures[1]), "\\\\") end, {}),
    after = i(0)
  })
)


local rec_enum
rec_enum = function()
  return sn(
    nil,
    c(1, {
      -- Order is important, sn(...) first would cause infinite loop of expansion.
      t(""),
      sn(nil, { t({ "", "  \\item " }), i(1), d(2, rec_enum, {}) }),
    })
  )
end

local enum = s(
  { trig = "enum", dsrc = "enumerate", snippetType = "autosnippet" },
  fmta([[
  \begin{enumerate}
    \item <content><cont>
  \end{enumerate}<after>
  ]], {
    content = i(1),
    cont = d(2, rec_enum, {}),
    after = i(0)
  })
)

local item = s(
  { trig = "itz", dsrc = "itemize", snippetType = "autosnippet" },
  fmta([[
  \begin{itemize}
    \item <content><cont>
  \end{itemize}<after>
  ]], {
    content = d(1, insert_copy_from_clipboard),
    cont = d(2, rec_enum, {}),
    after = i(0)
  })
)

local note = s(
  { trig = "note", dsrc = "note", snippetType = "autosnippet" },
  fmta([[
  \begin{note}
    <content>
  \end{note}<after>
  ]], {
    content = i(1),
    after = i(0)
  })
)

local get_closing = function(opening)
  -- (, [, { are empty because autopair takes care of it
  local closing = {
    ["("] = "",
    ["["] = "",
    ["{"] = "",
    ["<"] = ">",
  }
  if closing[opening] then
    return closing[opening]
  else
    return opening
  end
end

local brackets = s(
  { trig = "lr([^%w])", dsrc = "brackets", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
  { t("\\left"), f(function(_, snip) return snip.captures[1] end), t(" "), d(1, insert_copy_from_clipboard), t(
    " \\right"), f(function(_, snip) return get_closing(snip.captures[1]) end), i(0) },
  { condition = in_mathzone }
)

local sum = s(
  { trig = "sum", dsrc = "sum", snippetType = "autosnippet", condition = in_mathzone },
  fmta([[
  \sum_{<starts>}^{<ends>}<after>
  ]], { starts = i(1, "1"), ends = i(2, "\\infty"), after = i(0) })
)

local lim = s(
  { trig = "lim", dsrc = "limit", snippetType = "autosnippet", condition = in_mathzone },
  fmta([[
  \lim_{<starts> \to <ends>}<after>
  ]], { starts = i(1, "n"), ends = i(2, "\\infty"), after = i(0) })
)

local i1 = s(
  { trig = "=>", dsrc = "implies", snippetType = "autosnippet", condition = in_mathzone },
  { t("\\implies") }
)

local i2 = s(
  { trig = "=<", dsrc = "implied by", snippetType = "autosnippet", condition = in_mathzone },
  { t("\\impliedby") }
)

local math1 = s(
  { trig = "bf", dsrc = "bold face", snippetType = "autosnippet", condition = in_mathzone, wordTrig = false },
  { t("\\mathbf{"), i(1), t("}"), i(0) }
)

local math2 = s(
  { trig = "m([A-Z])([,.]?) ", dsrc = "italic", regTrig = true, snippetType = "autosnippet" },
  { t("$"), f(function(_, snip) return snip.captures[1] .. "$" .. snip.captures[2] .. " " end), i(0) }
)

local definition = s(
  { trig = "([\\]?)dfn", dsrc = "definition", snippetType = "autosnippet", regTrig = true },
  fmta([[
  \dfn{<heading>}{<content>}<after>
  ]], { heading = i(1), content = i(2), after = i(0) })
)

local subsection = s(
  { trig = "sub ", dsrc = "subsection", snippetType = "autosnippet" },
  fmta([[
  \subsection{<heading>}<after>
  ]], { heading = i(1), after = i(0) })
)

local subsection2 = s(
  { trig = "sub* ", dsrc = "subsection", snippetType = "autosnippet" },
  fmta([[
  \subsection*{<heading>}<after>
  ]], { heading = i(1), after = i(0) })
)

local beta1 = s(
  { trig = "bt", dsrc = "beta", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
  { t("\\beta") }
)

local beta2 = s(
  { trig = "\\beta0", dsrc = "beta0", snippetType = "autosnippet", condition = in_mathzone },
  { t("\\beta_0") }
)

local transpose = s(
  { trig = "T", dsrc = "transpose", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
  { t("^T") }
)

local text = s(
  { trig = "tt", dsrc = "text", snippetType = "autosnippet", condition = in_mathzone },
  { t("\\text{"), i(1), t("}"), i(0) }
)

local derivative = s(
  { trig = "([%d]?)der", dsrc = "derivative", snippetType = "autosnippet", regTrig = true, condition = in_mathzone },
  { d(1, function(_, snip)
    local pow = snip.captures[1]
    if pow ~= "" then
      return sn(nil, { t("\\frac{d^" .. pow .. "}{d"), i(1), t("}^" .. pow) })
    else
      return sn(nil, { t("\\frac{d}{d"), i(1), t("}") })
    end
  end, {}) }
)

local cdot = s(
  { trig = ". ", dsrc = "cdot", snippetType = "autosnippet", condition = in_mathzone },
  { t("\\cdot ") }
)

local binom = s(
  { trig = "([\\]?)bin", dsrc = "binomial", snippetType = "autosnippet", regTrig = true, condition = in_mathzone },
  fmta([[
  \binom{<n>}{<k>}<after>
  ]], { n = i(1), k = i(2), after = i(0) })
)

local rightarrow = s(
  {trig = "->", dsrc = "rightarrow", snippetType = "autosnippet", condition = in_mathzone},
  {t("\\rightarrow")}
)

return {
  sign, box, beg,
  mk, dm,
  sub1, sub2, sub3,
  sr, cb, sqrt, compl, td, us,
  frac1, frac2, frac3,
  sympy1, sympy2,
  bar1, bar2, hat1, hat2, vec,
  eqn, align1, align2, enum, item, note, brackets,
  sum, lim, derivative, i1, i2,
  math1, math2,
  definition, subsection, subsection2,
  beta1, beta2, transpose, text,
  cdot, binom,
  matrix1, matrix2, augmented_matrix1, augmented_matrix2, row_vector, col_vector,
  rightarrow,
}
