local in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end


      -- local first = '┌' .. string.rep('─', #text + 2) .. '┐'
      -- local middle = '│ ' .. text .. ' │'
      -- local last = '└' .. string.rep('─', #text + 2) .. '┘'

local sign = s(
  {trig = "sign", dsrc = "Signature"},
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
      top = f(function(args,_) return string.rep('─', #args[1][1] + 2) end, {1}),
      bottom = f(function(args,_) return string.rep('─', #args[1][1] + 2) end, {1}),
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
    .\] <after>
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
    trig = "([A-za-z])(%d)",
    dsrc = "subscript - type 1",
    regTrig = true,
    snippetType = "autosnippet"
  },
  f(to_subscript)
)

local sub2 = s(
  {
    trig = "([A-za-z])_(%d%d)",
    dsrc = "subscript - type 2",
    regTrig = true,
    snippetType = "autosnippet"
  },
  f(to_subscript)
)

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

local compl = s(
  { trig = "compl", dsrc = "complement", wordTrig = false, snippetType = "autosnippet" },
  t("^{c}"),
  { condition = in_mathzone }
)

local td = s(
  { trig = "td", dsrc = "superscript", wordTrig = false, snippetType = "autosnippet", },
  fmta([[^{<power>}<after>]], { power = i(1), after = i(0) })
)

local frac1 = s(
  { trig = "//", dsrc = "fraction - type 1", wordTrig = false, snippetType = "autosnippet" },
  fmta([[
  \frac{<num>}{<den>}
  ]], {
    num = i(1),
    den = i(2),
  })
  -- { condition = in_mathzone }
)

local frac2 = s(
  { trig = "((%d+)|(%d*)(\\)?([A-Za-z]+)((%^|_)(%{%d+%}|%d))*)/" }
)




return {
  sign,
  box,
  beg,
  mk,
  dm,
  sub1,
  sub2,
  sr,
  cb,
  compl,
  td,
  frac1
}
