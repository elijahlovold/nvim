local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node

ls.add_snippets("markdown", {

  s("yaml", {
    t({"---", "type: "}),
    c(1, {
      t("idea"),
      t("concept"),
      t("reference"),
      t("index"),
      t("media"),
      t("project"),
      t("question"),
      t("conversation"),
      t("person"),
    }),

    t({"", "status: "}),
    c(2, {
      t("idea"),
      t("wip"),
      t("complete"),
      t("perpetual"),
      t("archived"),
    }),

    i(3),
    t({
      "",
      "source:",
      "tags:",
      "---",
      "",
      ""
    })
  }),
})
