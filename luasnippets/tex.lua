-- use vimtex to determine if we are in a math context
local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

-- a helper function to generate arbitrarily sized matrices.
--https://github.com/evesdropper/luasnip-latex-snippets.nvim/blob/main/lua/luasnip-latex-snippets/luasnippets/tex/math.lua
local generate_matrix = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
	end
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end


--test whether the parent snippet has content from a visual selection. If yes, put into a text  node, if no then start an insert node
local visualSelectionOrInsert = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, t( parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
    s(
        {trig="eq", snippetType="snippet", dscr="A LaTeX equation environment"},
        fmta(
            [[
            \begin{equation}
                <>
            \end{equation}
            
            ]],
            { i(1) }
        )
    ),

    s(
        {trig="fig", snippetType="snippet", dscr="A basic figure environment"},
        fmta(
            [[
            \begin{figure}
            \centering
            \includegraphics[width=0.9\linewidth]{<>}
            \caption{
                \textbf{<>}
                <>
                }
            \label{fig:<>}
            \end{figure}

            ]],
            { i(1,"filename"),
              i(2, "captionBold"),
              i(3, "captionText"),
              i(4,"figureLabel"),
             }
        )
    ),

    s(
        {trig="env", snippetType="snippet", dscr="Begin and end an arbitrary environment"},
        fmta(
            [[
            \begin{<>}
                <>
            \end{<>}

            ]],
            {i(1),
             i(2),
             rep(1),
            }
        )
    ),

    s(
        {trig="cases", snippetType="snippet", dscr="Set up a case statement (requires amsmath)"},
        fmta(
            [[
            \begin{cases}
                <> & \text{<> $<>$} \\
                <> & \text{<> $<>$}
            \end{cases}
            ]],
            {i(1,"0"),
             i(2,"if"),
             i(3,"x<0"),
             i(4,"1"),
             i(5,"if"),
             i(6,"x>0"),
            }
        )
    ),

    s(
        {trig="mat", snippetType="snippet", dscr="Set up a 2x2 matrix (requires amsmath)", show_condition=math},
        fmta(
            [[
            \begin{pmatrix}
                <> & <> \\
                <> & <> 
            \end{pmatrix}
            ]],
            {i(1),
             i(2),
             i(3),
             i(4),
            }
        )
    ),
    -- arbitrarily sized matrices
    s({trig = "([%sbBpvV])Mat(%d+)x(%d+)", snippetType="autosnippet", regTrig = true, wordTrig=false, dscr = "[bBpvV]matrix of A x B size", show_condition=math},
        fmta([[
        \begin{<>}
        <>
        \end{<>}]],
        {
        f(function(_, snip)
            if  snip.captures[1] ==" " then
                return "matrix"
            else
                return snip.captures[1] .. "matrix"
            end
        end),
        d(1, generate_matrix),
        f(function(_, snip)
            if  snip.captures[1] ==" " then
                return "matrix"
            else
                return snip.captures[1] .. "matrix"
            end
        end),
        })
    ),
    --autotrigger greek letters, with choice nodes for pi/phi, epsilon/eta, tau/theta...
    s({trig=";a", snippetType="autosnippet", desc="alpha",wordTrig=false},
        {
            t("\\alpha"),
        },
        {condition =math }
    ),
    s({trig=";b", snippetType="autosnippet", desc="beta",wordTrig=false},
        {
            t("\\beta"),
        },
        {condition =math }
    ),
    s({trig=";B", snippetType="autosnippet", desc="Beta",wordTrig=false},
        {
            t("\\Beta"),
        },
        {condition =math }
    ),
    s({trig=";g", snippetType="autosnippet", desc="gamma",wordTrig=false},
        {
            t("\\gamma"),
        },
        {condition =math }
    ),
    s({trig=";G", snippetType="autosnippet", desc="Gamma",wordTrig=false},
        {
            t("\\Gamma"),
        },
        {condition =math }
    ),
    s({trig=";d", snippetType="autosnippet", desc="delta",wordTrig=false},
        {
            t("\\delta"),
        },
        {condition =math }
    ),
    s({trig=";D", snippetType="autosnippet", desc="Delta",wordTrig=false},
        {
            t("\\Delta"),
        },
        {condition =math }
    ),
    s({trig=";z", snippetType="autosnippet", desc="zeta",wordTrig=false},
        {
            t("\\zeta"),
        },
        {condition =math }
    ),
    s({trig=";k", snippetType="autosnippet", desc="kappa",wordTrig=false},
        {
            t("\\kappa"),
        },
        {condition =math }
    ),
    s({trig=";l", snippetType="autosnippet", desc="lambda",wordTrig=false},
        {
            t("\\lambda"),
        },
        {condition =math }
    ),
    s({trig=";m", snippetType="autosnippet", desc="mu",wordTrig=false},
        {
            t("\\mu"),
        },
        {condition =math }
    ),
    s({trig=";n", snippetType="autosnippet", desc="nu",wordTrig=false},
        {
            t("\\nu"),
        },
        {condition =math }
    ),
    s({trig=";x", snippetType="autosnippet", desc="xi",wordTrig=false},
        {
            t("\\xi"),
        },
        {condition =math }
    ),

    s({trig=";r", snippetType="autosnippet", desc="rho",wordTrig=false},
        {
            t("\\rho"),
        },
        {condition =math }
    ),
    s({trig=";s", snippetType="autosnippet", desc="sigma",wordTrig=false},
        {
            t("\\sigma"),
        },
        {condition =math }
    ),
    s({trig=";c", snippetType="autosnippet", desc="chi",wordTrig=false},
        {
            t("\\chi"),
        },
        {condition =math }
    ),
    s({trig=";w", snippetType="autosnippet", desc="omega",wordTrig=false},
        {
            t("\\omega"),
        },
        {condition =math }
    ),
    s({trig=";W", snippetType="autosnippet", desc="Omega",wordTrig=false},
        {
            t("\\Omega"),
        },
        {condition =math }
    ),
    s({trig=";t", snippetType="autosnippet", desc="tau",wordTrig=false},
        {
            t("\\tau"),
        },
        {condition =math }
    ),
    s({trig="\\tauh", snippetType="autosnippet", desc="theta",wordTrig=false},
        {
            t("\\theta"),
        },
        {condition =math }
    ),
    s({trig=";e", snippetType="autosnippet", desc="epsilon",wordTrig=false},
        {
            t("\\epsilon"),
        },
        {condition =math }
    ),
    s({trig="\\epsilont", snippetType="autosnippet", desc="eta",wordTrig=false},
        {
            t("\\eta"),
        },
        {condition =math }
    ),

    s({trig=";p", snippetType="autosnippet", desc="pi",wordTrig=false},
        {
            t("\\pi"),
        },
        {condition =math }
    ),
    s({trig="\\pih", snippetType="autosnippet", desc="phi",wordTrig=false},
        {
            t("\\phi"),
        },
        {condition =math }
    ),
    s({trig="\\pis", snippetType="autosnippet", desc="psi",wordTrig=false},
        {
            t("\\psi"),
        },
        {condition =math }
    ),
    s({trig=";O", snippetType="autosnippet", desc="mathcal O",wordTrig=false},
        {
            t("\\mathcal{O}"),
        },
        {condition =math }
    ),
    s({trig=";i", snippetType="autosnippet", desc="infinity",wordTrig=false},
        {
            t("\\infty"),
        },
        {condition =math }
    ),
    s({trig=";N", snippetType="autosnippet", desc="nabla",wordTrig=false},
        {
            t("\\nabla"),
        },
        {condition =math }
    ),
    s({trig="div", snippetType="autosnippet", desc="nabla",wordTrig=false},
        {
            t("\\nabla\\cdot"),
        },
        { condition=math }
    ),
    s({trig="grad", snippetType="autosnippet", desc="gradient",wordTrig=false},
        {
            t("\\nabla"),
        },
        { condition=math }
    ),
    s({trig="curl", snippetType="autosnippet", desc="curl",wordTrig=false},
        {
            t("\\nabla\\times"),
        },
        { condition=math }
    ),
    s({trig=";I",snippetType="autosnippet",desc="integral with infinite or inserted limits",wordTrig=false},
        fmta([[
            <>
            ]],
            {
            c(1,{
                t("\\int_{-\\infty}^\\infty",{key = "integral over all reals"}),
                sn(nil,fmta([[ \int_{<>}^{<>} ]],{i(1),i(2)}),{key = "integral with insert-node limits"}),
                })
            }
        )
    ),
    --postfixes for vectors, hats, etc. The match pattern is '\\' plus the default (so that hats get put on greek letters, etc)
    postfix({trig="hat", match_pattern = [[[\\%w%.%_%-%"%']+$]], snippetType="autosnippet",dscr="postfix hat when in math mode"},
        {l("\\hat{" .. l.POSTFIX_MATCH .. "}")}, 
        { condition=math }
    ) ,
    postfix({trig="vec", match_pattern = [[[\\%w%.%_%-%"%']+$]] ,snippetType="autosnippet",dscr="postfix vec when in math mode"},
        {l("\\vec{" .. l.POSTFIX_MATCH .. "}")}, 
        { condition=math }
    ) ,

    postfix({trig="df",snippetType="autosnippet",desc="postfix differential (physics package)"},
        {l("\\d{" .. l.POSTFIX_MATCH .. "}")}, 
        {condition = math}
    ),
    postfix({trig="diff",snippetType="autosnippet",desc="postfix differential (physics package)"},
        {l("\\dd{" .. l.POSTFIX_MATCH .. "}")}, 
        {condition = math}
    ),

    s({trig = "textbf", dscr = "the textbf command, either in insert mode or wrapping a visual selection"},
        fmta("\\textbf{<>}",
            {
                d(1, visualSelectionOrInsert),
            }
        )
    ),
    s({trig = "emph", dscr = "the emph command, either in insert mode or wrapping a visual selection"},
        fmta("\\emph{<>}",
            {
                d(1, visualSelectionOrInsert),
            }
        )
    ),

    s(
        {trig="href", snippetType="snippet", dscr="href with placeholders to remind you of the order"},
        fmta(
            [[\href{<>}{<>}]],
            {
            i(1, "url"),
            i(2, "display name"),
            }
        )
    ),

    --autotrigger latex quotation marks
    s({trig="quote", snippetType="snippet", desc="quotation marks (enquote)"},
        fmta(
            [[\enquote{<>}]],
            {
            i(1, "text"),
            }
        )
    ),
}
