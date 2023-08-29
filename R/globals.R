# remotes::install_github("thinkr-open/checkhelper")
# checkhelper::print_globals()

globalVariables(unique(c(
  # kobo_dico:
  "chapter", "chapternum", "label", "name", "repeatvar", "scope", "subchapter", "subchapternum", "type",
  # kobo_frame:
  "dataframe", "name",
  # kobo_indicator:
  "chapter", "subchapter", "subchapternum", "type",
  # kobo_likert:
  "appearance", "cnt", "dataframe", "list_name", "scope", "type",
  # kobo_prepare_form:
  "field_name", "form_placeholder", "help_text", "label", "name", "repeatvar", "required", "scope", "type", "value",
  # label_choiceset:
  "list_name", "name",
  # label_varhint:
  "hint", "name",
  # label_varname:
  "label", "name",
  # plot_correlation:
  "Freq", "Var1", "Var2",
  # plot_header:
  "name", "type",
  # plot_integer:
  ".data",
  # plot_integer_cross:
  ".data",
  # plot_likert:
  ".", "appearance", "dataframe", "label", "list_name", "name", "scope",
  # plot_select_multiple:
  ".data", "list_name", "listvar", "n", "name", "x", "X_id","data[[var]]",
  # plot_select_multiple_cross:
  ".data", "n", "pcum", "x", "X_id", "y", "data[[var]]", "rec", "y0", "y1",
  # plot_select_multiple_cross : <anonymous>:
  "pcum",
  # plot_select_one:
  ".data", "list_name", "n", "name", "x",
  # plot_select_one_cross:
  ".data", "n", "pcum", "x", "y", "y0",
  # plot_select_one_cross : <anonymous>:
  "pcum",
  # plot_text:
  ".", "freq", "removeNumbers", "removePunctuation", "removeWords", "stemDocument", "stripWhitespace", "word",
  # template_1_exploration:
  "country_asylum_iso3c", "year",
  # mod_home_server:
  "parent_session"
)))
