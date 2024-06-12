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
  { trig = [[((\d+)|(\d*)(\\)?([A-Za-z]+)((\^|_)(\{\d+\}|\d))*)/]], dsrc = "fraction - type 2", wordTrig = false, snippetType = "autosnippet", trigEngine = "ecma"},
  fmta([[
  \frac{<num>}{<den>}<after>
  ]], {
      num = f(function(_,snip) return snip.captures[1] end),
      den = i(1),
      after = i(0),
    })
)

local frac3 = s(
  { trig = "^(.*%))/", dsrc = "() fraction", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
  fmta([[
  <num>{<den>}<after>
  ]], {
      num = f(function(_,snip)
        local text = snip.captures[1]
        local stripped = text:sub(1, #text)
        local depth = 0
        local i = #stripped
        while true do
            if stripped:sub(i,i) == ")" then
                depth = depth + 1
            elseif stripped:sub(i,i) == "(" then
                depth = depth - 1
            end
            if depth == 0 or i < 1 then
                break
            end
            i = i - 1
        end
        return stripped:sub(1,i-1) .. "\\frac{" .. stripped:sub(i+1, #stripped-1) .. "}"
      end),
      den = i(1),
      after = i(0),
    })
)

local sympy1 = s( -- This snippets creates the sympy block ;)
    { trig = "sympy", desc = "Creates a sympy block", snippetType = "autosnippet"},
    fmt("sympy {} sympy{}",
        { i(1), i(0) }
    )
)

local sympy2 = s( -- This one evaluates anything inside the simpy block
    { trig = "sympy.*sympy ", wordTrig=false, regTrig = true, desc = "Sympy block evaluator", snippetType = "autosnippet", priority = 10000 },
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
  { trig = "bar", dsrc = "bar", snippetType = "autosnippet", priority = 10 },
  fmta([[
  \overline{<content>}<after>
  ]], {content = i(1), after = i(0)})
)

local bar2 = s(
  { trig = "([a-zA-Z])bar", dsrc = "bar with letter", regTrig = true, snippetType = "autosnippet", priority = 100 },
  fmta([[
  \overline{<content>}<after>
  ]], {content = f(function(_,snip) return snip.captures[1] end), after = i(0)})
)


local hat1 = s(
  { trig = "hat", dsrc = "hat", snippetType = "autosnippet", priority = 10 },
  fmta([[
  \hat{<content>}<after>
  ]], {content = i(1), after = i(0)})
)

local hat2 = s(
  { trig = "([a-zA-Z])hat", dsrc = "hat with letter", regTrig = true, snippetType = "autosnippet", priority = 100 },
  fmta([[
  \hat{<content>}<after>
  ]], {content = f(function(_,snip) return snip.captures[1] end), after = i(0)})
)

local vec = s(
  {trig = [[(\\?\w+)(,\.|\.,)]], dsrc = "vector", trigEngine = "ecma", snippetType = "autosnippet"},
  fmta([[
  \vec{<content>}<after>
  ]], {content = f(function(_,snip) return snip.captures[1] end), after = i(0)})
)


return {
  sign, box, beg,
  mk, dm,
  sub1, sub2,
  sr, cb, compl, td,
  frac1, frac2, frac3,
  sympy1, sympy2,
  bar1, bar2, hat1, hat2, vec
}
