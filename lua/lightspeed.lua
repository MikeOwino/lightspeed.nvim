local api = vim.api
local function inc(x)
  return (x + 1)
end
local function dec(x)
  return (x - 1)
end
local function clamp(val, min, max)
  if (val < min) then
    return min
  elseif (val > max) then
    return max
  elseif "else" then
    return val
  end
end
local function last(tbl)
  return tbl[#tbl]
end
local empty_3f = vim.tbl_isempty
local function reverse_lookup(tbl)
  local tbl_0_ = {}
  for k, v in ipairs(tbl) do
    local _0_0, _1_0 = v, k
    if ((nil ~= _0_0) and (nil ~= _1_0)) then
      local k_0_ = _0_0
      local v_0_ = _1_0
      tbl_0_[k_0_] = v_0_
    end
  end
  return tbl_0_
end
local function echo(msg)
  vim.cmd("redraw")
  return api.nvim_echo({{msg}}, false, {})
end
local function replace_vim_keycodes(s)
  return api.nvim_replace_termcodes(s, true, false, true)
end
local function operator_pending_mode_3f()
  return string.match(api.nvim_get_mode().mode, "o")
end
local function yank_operation_3f()
  return (operator_pending_mode_3f() and (vim.v.operator == "y"))
end
local function change_operation_3f()
  return (operator_pending_mode_3f() and (vim.v.operator == "c"))
end
local function delete_operation_3f()
  return (operator_pending_mode_3f() and (vim.v.operator == "d"))
end
local function dot_repeatable_operation_3f()
  return (operator_pending_mode_3f() and (vim.v.operator ~= "y"))
end
local function get_current_pos()
  return {vim.fn.line("."), vim.fn.col(".")}
end
local function get_char_at_pos(_0_0, _1_0)
  local _arg_0_ = _0_0
  local line = _arg_0_[1]
  local byte_col = _arg_0_[2]
  local _arg_1_ = _1_0
  local char_offset = _arg_1_["char-offset"]
  local line_str = vim.fn.getline(line)
  local char_idx = vim.fn.charidx(line_str, dec(byte_col))
  local char_nr = vim.fn.strgetchar(line_str, (char_idx + (char_offset or 0)))
  if (char_nr ~= -1) then
    return vim.fn.nr2char(char_nr)
  end
end
local function skip_to_fold_edge_21(reverse_3f)
  local _2_0
  local _3_
  if reverse_3f then
    _3_ = vim.fn.foldclosed
  else
    _3_ = vim.fn.foldclosedend
  end
  _2_0 = _3_(vim.fn.line("."))
  if (_2_0 == -1) then
    return "not-in-fold"
  elseif (nil ~= _2_0) then
    local fold_edge = _2_0
    vim.fn.cursor(fold_edge, 0)
    local function _5_()
      if reverse_3f then
        return 1
      else
        return vim.fn.col("$")
      end
    end
    vim.fn.cursor(0, _5_())
    return "moved-the-cursor"
  end
end
local opts = {cycle_group_bwd_key = nil, cycle_group_fwd_key = nil, full_inclusive_prefix_key = "<c-x>", grey_out_search_area = true, highlight_unique_chars = false, jump_on_partial_input_safety_timeout = 400, jump_to_first_match = true, labels = nil, limit_ft_matches = 5, match_only_the_start_of_same_char_seqs = true}
local function setup(user_opts)
  opts = setmetatable(user_opts, {__index = opts})
  return nil
end
local hl
local function _2_(self, hl_group, line, startcol, endcol)
  return api.nvim_buf_add_highlight(0, self.ns, hl_group, line, startcol, endcol)
end
local function _3_(self, line, col, opts0)
  return api.nvim_buf_set_extmark(0, self.ns, line, col, opts0)
end
local function _4_(self)
  return api.nvim_buf_clear_namespace(0, self.ns, 0, -1)
end
hl = {["add-hl"] = _2_, ["set-extmark"] = _3_, cleanup = _4_, group = {["label-distant"] = "LightspeedLabelDistant", ["label-distant-overlapped"] = "LightspeedLabelDistantOverlapped", ["label-overlapped"] = "LightspeedLabelOverlapped", ["matching-ch"] = "LightspeedMatchingChar", ["one-char-match"] = "LightspeedOneCharMatch", ["pending-change-op-area"] = "LightspeedPendingChangeOpArea", ["pending-op-area"] = "LightspeedPendingOpArea", ["shortcut-overlapped"] = "LightspeedShortcutOverlapped", ["unique-ch"] = "LightspeedUniqueChar", ["unlabeled-match"] = "LightspeedUnlabeledMatch", greywash = "LightspeedGreyWash", label = "LightspeedLabel", shortcut = "LightspeedShortcut"}, ns = api.nvim_create_namespace("")}
local function init_highlight()
  local bg = vim.o.background
  local groupdefs
  local _6_
  do
    local _5_0 = bg
    if (_5_0 == "light") then
      _6_ = "#f02077"
    else
      local _ = _5_0
      _6_ = "#ff2f87"
    end
  end
  local _8_
  do
    local _7_0 = bg
    if (_7_0 == "light") then
      _8_ = "#ff4090"
    else
      local _ = _7_0
      _8_ = "#e01067"
    end
  end
  local _10_
  do
    local _9_0 = bg
    if (_9_0 == "light") then
      _10_ = "#399d9f"
    else
      local _ = _9_0
      _10_ = "#99ddff"
    end
  end
  local _12_
  do
    local _11_0 = bg
    if (_11_0 == "light") then
      _12_ = "#59bdbf"
    else
      local _ = _11_0
      _12_ = "#79bddf"
    end
  end
  local _14_
  do
    local _13_0 = bg
    if (_13_0 == "light") then
      _14_ = "#272020"
    else
      local _ = _13_0
      _14_ = "#f3ecec"
    end
  end
  local _16_
  do
    local _15_0 = bg
    if (_15_0 == "light") then
      _16_ = "#f02077"
    else
      local _ = _15_0
      _16_ = "#ff2f87"
    end
  end
  groupdefs = {{hl.group.label, ("guifg=" .. _6_ .. " gui=bold,underline")}, {hl.group["label-overlapped"], ("guifg=" .. _8_ .. " gui=underline")}, {hl.group["label-distant"], ("guifg=" .. _10_ .. " gui=bold,underline")}, {hl.group["label-distant-overlapped"], ("guifg=" .. _12_ .. " gui=underline")}, {hl.group.shortcut, "guibg=#f00077 guifg=#ffffff gui=bold,underline"}, {hl.group["one-char-match"], "guibg=#f00077 guifg=#ffffff gui=bold"}, {hl.group["matching-ch"], "guifg=#cc9999"}, {hl.group["unlabeled-match"], ("guifg=" .. _14_ .. " gui=bold")}, {hl.group["pending-op-area"], "guibg=#f00077 guifg=#ffffff"}, {hl.group["pending-change-op-area"], ("guifg=" .. _16_ .. " gui=strikethrough")}, {hl.group.greywash, "guifg=#777777"}}
  for _, _17_0 in ipairs(groupdefs) do
    local _each_0_ = _17_0
    local group = _each_0_[1]
    local attrs = _each_0_[2]
    vim.cmd(("highlight default " .. group .. " " .. attrs))
  end
  for _, _17_0 in ipairs({{hl.group["unique-ch"], hl.group["unlabeled-match"]}, {hl.group["shortcut-overlapped"], hl.group.shortcut}}) do
    local _each_0_ = _17_0
    local from_group = _each_0_[1]
    local to_group = _each_0_[2]
    vim.cmd(("highlight default link " .. from_group .. " " .. to_group))
  end
  return nil
end
init_highlight()
local function add_highlight_autocmds()
  vim.cmd("augroup LightspeedInitHighlight")
  vim.cmd("autocmd!")
  vim.cmd("autocmd ColorScheme * lua require'lightspeed'.init_highlight()")
  return vim.cmd("augroup end")
end
add_highlight_autocmds()
local function highlight_area_between(_5_0, _6_0, hl_group)
  local _arg_0_ = _5_0
  local startline = _arg_0_[1]
  local startcol = _arg_0_[2]
  local _arg_1_ = _6_0
  local endline = _arg_1_[1]
  local endcol = _arg_1_[2]
  local add_hl
  local function _7_(...)
    return hl["add-hl"](hl, hl_group, ...)
  end
  add_hl = _7_
  if (startline == endline) then
    return add_hl(startline, startcol, endcol)
  else
    add_hl(startline, startcol, -1)
    for line = inc(startline), dec(endline) do
      add_hl(line, 0, -1)
    end
    return add_hl(endline, 0, endcol)
  end
end
local function grey_out_search_area(reverse_3f)
  local _let_0_ = vim.tbl_map(dec, get_current_pos())
  local curline = _let_0_[1]
  local curcol = _let_0_[2]
  local _let_1_ = {dec(vim.fn.line("w0")), dec(vim.fn.line("w$"))}
  local win_top = _let_1_[1]
  local win_bot = _let_1_[2]
  local function _7_()
    if reverse_3f then
      return {{win_top, 0}, {curline, curcol}}
    else
      return {{curline, inc(curcol)}, {win_bot, -1}}
    end
  end
  local _let_2_ = _7_()
  local startpos = _let_2_[1]
  local endpos = _let_2_[2]
  return highlight_area_between(startpos, endpos, hl.group.greywash)
end
local function echo_no_prev_search()
  return echo("no previous search")
end
local function echo_not_found(s)
  return echo(("not found: " .. s))
end
local function get_char()
  local ch = vim.fn.getchar()
  if (type(ch) == "number") then
    return vim.fn.nr2char(ch)
  else
    return ch
  end
end
local function force_statusline_update()
  vim.o.statusline = vim.o.statusline
  return nil
end
local function push_cursor_21(direction)
  local function _8_()
    local _7_0 = direction
    if (_7_0 == "fwd") then
      return "W"
    elseif (_7_0 == "bwd") then
      return "bW"
    end
  end
  return vim.fn.search("\\_.", _8_())
end
local function onscreen_match_positions(pattern, reverse_3f, _3flimit)
  local view = vim.fn.winsaveview()
  local cpo = vim.o.cpo
  local opts0
  if reverse_3f then
    opts0 = "b"
  else
    opts0 = ""
  end
  local stopline
  local function _8_()
    if reverse_3f then
      return "w0"
    else
      return "w$"
    end
  end
  stopline = vim.fn.line(_8_())
  local cleanup
  local function _9_()
    vim.fn.winrestview(view)
    vim.o.cpo = cpo
    return nil
  end
  cleanup = _9_
  vim.o.cpo = cpo:gsub("c", "")
  local match_count = 0
  local function rec()
    if (_3flimit and (match_count >= _3flimit)) then
      return cleanup()
    else
      local _10_0 = vim.fn.searchpos(pattern, opts0, stopline)
      if ((type(_10_0) == "table") and ((_10_0)[1] == 0) and true) then
        local _ = (_10_0)[2]
        return cleanup()
      elseif (nil ~= _10_0) then
        local pos = _10_0
        local _11_0 = skip_to_fold_edge_21(reverse_3f)
        if (_11_0 == "moved-the-cursor") then
          return rec()
        elseif (_11_0 == "not-in-fold") then
          match_count = (match_count + 1)
          return pos
        end
      end
    end
  end
  return rec
end
local function highlight_unique_chars(reverse_3f, ignorecase)
  local unique_chars = {}
  for pos in onscreen_match_positions("..", reverse_3f) do
    local ch = get_char_at_pos(pos, {})
    local _8_
    do
      local _7_0 = unique_chars[ch]
      if (_7_0 == nil) then
        _8_ = pos
      else
        local _ = _7_0
        _8_ = false
      end
    end
    unique_chars[ch] = _8_
  end
  for ch, pos_or_false in pairs(unique_chars) do
    if pos_or_false then
      local _let_0_ = pos_or_false
      local line = _let_0_[1]
      local col = _let_0_[2]
      hl["set-extmark"](hl, dec(line), dec(col), {virt_text = {{ch, hl.group["unique-ch"]}}, virt_text_pos = "overlay"})
    end
  end
  return nil
end
local function highlight_cursor(_3fpos)
  local _let_0_ = (_3fpos or get_current_pos())
  local line = _let_0_[1]
  local col = _let_0_[2]
  local pos = _let_0_
  local ch_at_curpos = (get_char_at_pos(pos, {}) or " ")
  return hl["set-extmark"](hl, dec(line), dec(col), {hl_mode = "combine", virt_text = {{ch_at_curpos, "Cursor"}}, virt_text_pos = "overlay"})
end
local function handle_interrupted_change_op_21()
  echo("")
  local curcol = vim.fn.col(".")
  local endcol = vim.fn.col("$")
  local _3fright
  if (not vim.o.insertmode and (curcol > 1) and (curcol < endcol)) then
    _3fright = "<RIGHT>"
  else
    _3fright = ""
  end
  return api.nvim_feedkeys(replace_vim_keycodes(("<C-\\><C-G>" .. _3fright)), "n", true)
end
local function get_input_and_clean_up()
  local ok_3f, res = pcall(get_char)
  hl:cleanup()
  if (ok_3f and (res ~= replace_vim_keycodes("<esc>"))) then
    return res
  else
    if change_operation_3f() then
      handle_interrupted_change_op_21()
    end
    do
    end
    return nil
  end
end
local function set_dot_repeat(_7_0)
  local _arg_0_ = _7_0
  local cmd = _arg_0_["cmd"]
  local count = _arg_0_["count"]
  if operator_pending_mode_3f() then
    local op = vim.v.operator
    if (op ~= "y") then
      local change
      if (op == "c") then
        change = replace_vim_keycodes("<c-r>.<esc>")
      else
      change = nil
      end
      local seq = (op .. (count or "") .. cmd .. (change or ""))
      pcall(vim.fn["repeat#setreg"], seq, vim.v.register)
      return pcall(vim.fn["repeat#set"], seq, -1)
    end
  end
end
local ft = {["instant-repeat?"] = nil, ["prev-dot-repeatable-search"] = nil, ["prev-search"] = nil, ["started-reverse?"] = nil}
ft.to = function(self, reverse_3f, t_like_3f, dot_repeat_3f)
  local _let_0_ = self
  local instant_repeat_3f = _let_0_["instant-repeat?"]
  local started_reverse_3f = _let_0_["started-reverse?"]
  local _
  if not instant_repeat_3f then
    self["started-reverse?"] = reverse_3f
    _ = nil
  else
  _ = nil
  end
  local reverse_3f0
  if instant_repeat_3f then
    reverse_3f0 = ((not reverse_3f and started_reverse_3f) or (reverse_3f and not started_reverse_3f))
  else
    reverse_3f0 = reverse_3f
  end
  local count
  if (instant_repeat_3f and t_like_3f) then
    count = inc(vim.v.count1)
  else
    count = vim.v.count1
  end
  local op_mode_3f = operator_pending_mode_3f()
  local dot_repeatable_op_3f = dot_repeatable_operation_3f()
  local motion
  if (not t_like_3f and not reverse_3f0) then
    motion = "f"
  elseif (not t_like_3f and reverse_3f0) then
    motion = "F"
  elseif (t_like_3f and not reverse_3f0) then
    motion = "t"
  elseif (t_like_3f and reverse_3f0) then
    motion = "T"
  else
  motion = nil
  end
  local cmd_for_dot_repeat = (replace_vim_keycodes("<Plug>Lightspeed_repeat_") .. motion)
  if not (instant_repeat_3f or dot_repeat_3f) then
    echo("")
    highlight_cursor()
    vim.cmd("redraw")
  end
  local repeat_3f = nil
  local _13_0
  if instant_repeat_3f then
    _13_0 = self["prev-search"]
  elseif dot_repeat_3f then
    _13_0 = self["prev-dot-repeatable-search"]
  else
    local _14_0 = get_input_and_clean_up()
    if (_14_0 == "\13") then
      repeat_3f = true
      local function _15_()
        if change_operation_3f() then
          handle_interrupted_change_op_21()
        end
        do
          echo_no_prev_search()
        end
        return nil
      end
      _13_0 = (self["prev-search"] or _15_())
    elseif (nil ~= _14_0) then
      local _in = _14_0
      _13_0 = _in
    else
    _13_0 = nil
    end
  end
  if (nil ~= _13_0) then
    local in1 = _13_0
    local new_search_3f = not (repeat_3f or instant_repeat_3f or dot_repeat_3f)
    if new_search_3f then
      if dot_repeatable_op_3f then
        self["prev-dot-repeatable-search"] = in1
        set_dot_repeat({cmd = cmd_for_dot_repeat, count = count})
      else
        self["prev-search"] = in1
      end
    end
    local i = 0
    local target_pos = nil
    local function _17_()
      local pattern = ("\\V" .. in1:gsub("\\", "\\\\"))
      local _3flimit
      if opts.limit_ft_matches then
        _3flimit = (count + opts.limit_ft_matches)
      else
      _3flimit = nil
      end
      return onscreen_match_positions(pattern, reverse_3f0, _3flimit)
    end
    for _16_0 in _17_() do
      local _each_0_ = _16_0
      local line = _each_0_[1]
      local col = _each_0_[2]
      local pos = _each_0_
      i = (i + 1)
      if (i <= count) then
        target_pos = pos
      else
        if not op_mode_3f then
          hl["add-hl"](hl, hl.group["one-char-match"], dec(line), dec(col), col)
        end
      end
    end
    if (i == 0) then
      if change_operation_3f() then
        handle_interrupted_change_op_21()
      end
      do
        echo_not_found(in1)
      end
      return nil
    else
      if not instant_repeat_3f then
        vim.cmd("norm! m`")
      end
      vim.fn.cursor(target_pos)
      if t_like_3f then
        local function _17_()
          if reverse_3f0 then
            return "fwd"
          else
            return "bwd"
          end
        end
        push_cursor_21(_17_())
      end
      if (op_mode_3f and not reverse_3f0) then
        push_cursor_21("fwd")
      end
      if not op_mode_3f then
        highlight_cursor()
        vim.cmd("redraw")
        local ok_3f, in2 = pcall(get_char)
        self["instant-repeat?"] = (ok_3f and string.match(vim.fn.maparg(in2), "<Plug>Lightspeed_[fFtT]"))
        local function _19_()
          if ok_3f then
            return in2
          else
            return replace_vim_keycodes("<esc>")
          end
        end
        vim.fn.feedkeys(_19_())
      end
      return hl:cleanup()
    end
  end
end
local function get_labels()
  local function _8_()
    if opts.jump_to_first_match then
      return {"s", "f", "n", "/", "u", "t", "q", "S", "F", "G", "H", "L", "M", "N", "?", "U", "R", "Z", "T", "Q"}
    else
      return {"f", "j", "d", "k", "s", "l", "a", ";", "e", "i", "w", "o", "g", "h", "v", "n", "c", "m", "z", "."}
    end
  end
  return (opts.labels or _8_())
end
local function get_cycle_keys()
  local function _8_()
    if opts.jump_to_first_match then
      return "<tab>"
    else
      return "<space>"
    end
  end
  local function _9_()
    if opts.jump_to_first_match then
      return "<s-tab>"
    else
      return "<s-space>"
    end
  end
  return {(opts.cycle_group_fwd_key or replace_vim_keycodes(_8_())), (opts.cycle_group_bwd_key or replace_vim_keycodes(_9_()))}
end
local function get_match_map_for(ch1, reverse_3f)
  local match_map = {}
  local prefix = "\\V\\C"
  local input = ch1:gsub("\\", "\\\\")
  local pattern = (prefix .. input .. "\\.")
  local match_count = 0
  local prev = {}
  for _8_0 in onscreen_match_positions(pattern, reverse_3f) do
    local _each_0_ = _8_0
    local line = _each_0_[1]
    local col = _each_0_[2]
    local pos = _each_0_
    local overlap_with_prev_3f
    local _9_
    if reverse_3f then
      _9_ = dec
    else
      _9_ = inc
    end
    overlap_with_prev_3f = ((line == prev.line) and (col == _9_(prev.col)))
    local ch2 = get_char_at_pos(pos, {["char-offset"] = 1})
    local same_pair_3f = (ch2 == prev.ch2)
    local _11_
    if not opts.match_only_the_start_of_same_char_seqs then
      _11_ = prev["skipped?"]
    else
    _11_ = nil
    end
    if (_11_ or not (overlap_with_prev_3f and same_pair_3f)) then
      local partially_covered_3f = (overlap_with_prev_3f and not reverse_3f)
      if not match_map[ch2] then
        match_map[ch2] = {}
      end
      table.insert(match_map[ch2], {line, col, partially_covered_3f, __fnl_global___3fch3})
      if (overlap_with_prev_3f and reverse_3f) then
        last(match_map[prev.ch2])[3] = true
      end
      prev = {["skipped?"] = false, ch2 = ch2, col = col, line = line}
      match_count = (match_count + 1)
    else
      prev = {["skipped?"] = true, ch2 = ch2, col = col, line = line}
    end
  end
  local _8_0 = match_count
  if (_8_0 == 0) then
    return nil
  elseif (_8_0 == 1) then
    local ch2 = vim.tbl_keys(match_map)[1]
    local pos = vim.tbl_values(match_map)[1][1]
    return {ch2, pos}
  else
    local _ = _8_0
    return match_map
  end
end
local function set_beacon_at(_8_0, field1_ch, field2_ch, _9_0)
  local _arg_0_ = _8_0
  local line = _arg_0_[1]
  local col = _arg_0_[2]
  local partially_covered_3f = _arg_0_[3]
  local pos = _arg_0_
  local _arg_1_ = _9_0
  local distant_3f = _arg_1_["distant?"]
  local init_round_3f = _arg_1_["init-round?"]
  local repeat_3f = _arg_1_["repeat?"]
  local shortcut_3f = _arg_1_["shortcut?"]
  local unlabeled_3f = _arg_1_["unlabeled?"]
  local partially_covered_3f0
  if not repeat_3f then
    partially_covered_3f0 = partially_covered_3f
  else
  partially_covered_3f0 = nil
  end
  local shortcut_3f0
  if not repeat_3f then
    shortcut_3f0 = shortcut_3f
  else
  shortcut_3f0 = nil
  end
  local label_hl
  if shortcut_3f0 then
    label_hl = hl.group.shortcut
  elseif distant_3f then
    label_hl = hl.group["label-distant"]
  else
    label_hl = hl.group.label
  end
  local overlapped_label_hl
  if distant_3f then
    overlapped_label_hl = hl.group["label-distant-overlapped"]
  else
    if shortcut_3f0 then
      overlapped_label_hl = hl.group["shortcut-overlapped"]
    else
      overlapped_label_hl = hl.group["label-overlapped"]
    end
  end
  local function _14_()
    if unlabeled_3f then
      if partially_covered_3f0 then
        return {inc(col), {field2_ch, hl.group["unlabeled-match"]}, nil}
      else
        return {col, {field1_ch, hl.group["unlabeled-match"]}, {field2_ch, hl.group["unlabeled-match"]}}
      end
    elseif partially_covered_3f0 then
      if init_round_3f then
        return {inc(col), {field2_ch, overlapped_label_hl}, nil}
      else
        return {col, {field1_ch, hl.group["matching-ch"]}, {field2_ch, overlapped_label_hl}}
      end
    elseif repeat_3f then
      return {inc(col), {field2_ch, label_hl}, nil}
    elseif "else" then
      return {col, {field1_ch, hl.group["matching-ch"]}, {field2_ch, label_hl}}
    end
  end
  local _let_0_ = _14_()
  local col0 = _let_0_[1]
  local chunk1 = _let_0_[2]
  local _3fchunk2 = _let_0_[3]
  return hl["set-extmark"](hl, dec(line), dec(col0), {end_col = col0, virt_text = {chunk1, _3fchunk2}, virt_text_pos = "overlay"})
end
local function set_beacon_groups(ch2, positions, labels, shortcuts, _10_0)
  local _arg_0_ = _10_0
  local group_offset = _arg_0_["group-offset"]
  local init_round_3f = _arg_0_["init-round?"]
  local repeat_3f = _arg_0_["repeat?"]
  local group_offset0 = (group_offset or 0)
  local _7clabels_7c = #labels
  local set_group
  local function _11_(start, distant_3f)
    for i = start, dec((start + _7clabels_7c)) do
      if ((i < 1) or (i > #positions)) then break end
      local pos = positions[i]
      local label = (labels[(i % _7clabels_7c)] or labels[_7clabels_7c])
      local shortcut_3f
      if not distant_3f then
        shortcut_3f = shortcuts[pos]
      else
      shortcut_3f = nil
      end
      set_beacon_at(pos, ch2, label, {["distant?"] = distant_3f, ["init-round?"] = init_round_3f, ["repeat?"] = repeat_3f, ["shortcut?"] = shortcut_3f})
    end
    return nil
  end
  set_group = _11_
  local start = inc((group_offset0 * _7clabels_7c))
  local _end = dec((start + _7clabels_7c))
  set_group(start, false)
  return set_group((start + _7clabels_7c), true)
end
local function get_shortcuts(match_map, labels, reverse_3f, jump_to_first_3f)
  local collides_with_a_ch2_3f
  local function _11_(_241)
    return vim.tbl_contains(vim.tbl_keys(match_map), _241)
  end
  collides_with_a_ch2_3f = _11_
  local by_distance_from_cursor
  local function _14_(_12_0, _13_0)
    local _arg_0_ = _12_0
    local _arg_1_ = _arg_0_[1]
    local l1 = _arg_1_[1]
    local c1 = _arg_1_[2]
    local _ = _arg_0_[2]
    local _0 = _arg_0_[3]
    local _arg_2_ = _13_0
    local _arg_3_ = _arg_2_[1]
    local l2 = _arg_3_[1]
    local c2 = _arg_3_[2]
    local _1 = _arg_2_[2]
    local _2 = _arg_2_[3]
    if (l1 == l2) then
      if reverse_3f then
        return (c1 > c2)
      else
        return (c1 < c2)
      end
    else
      if reverse_3f then
        return (l1 > l2)
      else
        return (l1 < l2)
      end
    end
  end
  by_distance_from_cursor = _14_
  local shortcuts = {}
  for ch2, positions in pairs(match_map) do
    for i, pos in ipairs(positions) do
      local labeled_pos_3f = not ((#positions == 1) or (jump_to_first_3f and (i == 1)))
      if labeled_pos_3f then
        local _15_0
        local _16_
        if jump_to_first_3f then
          _16_ = dec(i)
        else
          _16_ = i
        end
        _15_0 = labels[_16_]
        if (nil ~= _15_0) then
          local label = _15_0
          if not collides_with_a_ch2_3f(label) then
            table.insert(shortcuts, {pos, label, ch2})
          end
        end
      end
    end
  end
  table.sort(shortcuts, by_distance_from_cursor)
  local lookup_by_pos
  do
    local labels_used_up = {}
    local tbl_0_ = {}
    for _, _15_0 in ipairs(shortcuts) do
      local _each_0_ = _15_0
      local pos = _each_0_[1]
      local label = _each_0_[2]
      local ch2 = _each_0_[3]
      local _16_0, _17_0 = nil, nil
      if not labels_used_up[label] then
        labels_used_up[label] = true
        _16_0, _17_0 = pos, {label, ch2}
      else
      _16_0, _17_0 = nil
      end
      if ((nil ~= _16_0) and (nil ~= _17_0)) then
        local k_0_ = _16_0
        local v_0_ = _17_0
        tbl_0_[k_0_] = v_0_
      end
    end
    lookup_by_pos = tbl_0_
  end
  local lookup_by_label
  do
    local tbl_0_ = {}
    for pos, _15_0 in pairs(lookup_by_pos) do
      local _each_0_ = _15_0
      local label = _each_0_[1]
      local ch2 = _each_0_[2]
      local _16_0, _17_0 = label, {pos, ch2}
      if ((nil ~= _16_0) and (nil ~= _17_0)) then
        local k_0_ = _16_0
        local v_0_ = _17_0
        tbl_0_[k_0_] = v_0_
      end
    end
    lookup_by_label = tbl_0_
  end
  return vim.tbl_extend("error", lookup_by_pos, lookup_by_label)
end
local function ignore_char_until_timeout(char_to_ignore)
  local start = os.clock()
  local timeout_secs = (opts.jump_on_partial_input_safety_timeout / 1000)
  local ok_3f, input = pcall(get_char)
  if not ((input == char_to_ignore) and (os.clock() < (start + timeout_secs))) then
    if ok_3f then
      return vim.fn.feedkeys(input)
    end
  end
end
local s = {["prev-dot-repeatable-search"] = {["full-incl?"] = nil, in1 = nil, in2 = nil, in3 = nil}, ["prev-search"] = {in1 = nil, in2 = nil}}
s.to = function(self, reverse_3f, dot_repeat_3f)
  local op_mode_3f = operator_pending_mode_3f()
  local change_op_3f = change_operation_3f()
  local delete_op_3f = delete_operation_3f()
  local dot_repeatable_op_3f = dot_repeatable_operation_3f()
  local full_inclusive_prefix_key = replace_vim_keycodes(opts.full_inclusive_prefix_key)
  local _let_0_ = get_cycle_keys()
  local cycle_fwd_key = _let_0_[1]
  local cycle_bwd_key = _let_0_[2]
  local labels = get_labels()
  local label_indexes = reverse_lookup(labels)
  local jump_to_first_3f = (opts.jump_to_first_match and not op_mode_3f)
  local cmd_for_dot_repeat
  local function _11_()
    if reverse_3f then
      return "S"
    else
      return "s"
    end
  end
  cmd_for_dot_repeat = replace_vim_keycodes(("<Plug>Lightspeed_repeat_" .. _11_()))
  local function save_for(_12_0)
    local _arg_0_ = _12_0
    local dot_repeat = _arg_0_["dot-repeat"]
    local _repeat = _arg_0_["repeat"]
    if dot_repeatable_op_3f then
      self["prev-dot-repeatable-search"] = dot_repeat
      return nil
    else
      self["prev-search"] = _repeat
      return nil
    end
  end
  local function set_dot_repeat_if_applies()
    if (dot_repeatable_op_3f and not dot_repeat_3f) then
      return set_dot_repeat({cmd = cmd_for_dot_repeat})
    end
  end
  local jump_to_21
  do
    local first_jump_3f = true
    local function _13_(pos, full_incl_3f)
      if first_jump_3f then
        vim.cmd("norm! m`")
        first_jump_3f = false
      end
      vim.fn.cursor(pos)
      if (full_incl_3f and not reverse_3f) then
        push_cursor_21("fwd")
        if op_mode_3f then
          return push_cursor_21()
        end
      end
    end
    jump_to_21 = _13_
  end
  local function jump_and_ignore_ch2_until_timeout_21(_13_0, full_incl_3f, new_search_3f, ch2)
    local _arg_0_ = _13_0
    local line = _arg_0_[1]
    local col = _arg_0_[2]
    local _ = _arg_0_[3]
    local pos = _arg_0_
    local from_pos = get_current_pos()
    jump_to_21(pos, full_incl_3f)
    if new_search_3f then
      if not change_op_3f then
        local function _14_()
          if (op_mode_3f and not reverse_3f) then
            return from_pos
          end
        end
        highlight_cursor(_14_())
      end
      if op_mode_3f then
        local _let_1_ = {vim.tbl_map(dec, from_pos), {dec(line), dec(col)}}
        local from_pos0 = _let_1_[1]
        local to_pos = _let_1_[2]
        local function _15_()
          if reverse_3f then
            return {to_pos, from_pos0}
          else
            return {from_pos0, to_pos}
          end
        end
        local _let_2_ = _15_()
        local startpos = _let_2_[1]
        local endpos = _let_2_[2]
        local hl_group
        if (change_op_3f or delete_op_3f) then
          hl_group = hl.group["pending-change-op-area"]
        else
          hl_group = hl.group["pending-op-area"]
        end
        highlight_area_between(startpos, endpos, hl_group)
      end
      vim.cmd("redraw")
      ignore_char_until_timeout(ch2)
      if change_op_3f then
        echo("")
      end
      return hl:cleanup()
    end
  end
  if not dot_repeat_3f then
    echo("")
    if opts.grey_out_search_area then
      grey_out_search_area(reverse_3f)
    end
    do
      if opts.highlight_unique_chars then
        highlight_unique_chars(reverse_3f)
      end
    end
    highlight_cursor()
    vim.cmd("redraw")
  end
  local repeat_3f = nil
  local new_search_3f = nil
  local full_incl_3f = nil
  local _15_0
  if dot_repeat_3f then
    full_incl_3f = self["prev-dot-repeatable-search"]["full-incl?"]
    _15_0 = self["prev-dot-repeatable-search"].in1
  else
    local _16_0 = get_input_and_clean_up()
    if (nil ~= _16_0) then
      local in0 = _16_0
      repeat_3f = (in0 == "\13")
      new_search_3f = not (repeat_3f or dot_repeat_3f)
      full_incl_3f = (in0 == full_inclusive_prefix_key)
      if repeat_3f then
        local function _17_()
          if change_operation_3f() then
            handle_interrupted_change_op_21()
          end
          do
            echo_no_prev_search()
          end
          return nil
        end
        _15_0 = (self["prev-search"].in1 or _17_())
      elseif full_incl_3f then
        _15_0 = get_input_and_clean_up()
      else
        _15_0 = in0
      end
    else
    _15_0 = nil
    end
  end
  if (nil ~= _15_0) then
    local in1 = _15_0
    local _17_0
    local function _18_()
      if change_operation_3f() then
        handle_interrupted_change_op_21()
      end
      do
        local function _20_()
          if repeat_3f then
            return (in1 .. self["prev-search"].in2)
          elseif dot_repeat_3f then
            return (in1 .. self["prev-dot-repeatable-search"].in2)
          else
            return in1
          end
        end
        echo_not_found(_20_())
      end
      return nil
    end
    _17_0 = (get_match_map_for(in1, reverse_3f) or _18_())
    if ((type(_17_0) == "table") and (nil ~= (_17_0)[1]) and (nil ~= (_17_0)[2])) then
      local ch2 = (_17_0)[1]
      local pos = (_17_0)[2]
      if (new_search_3f or (repeat_3f and (ch2 == self["prev-search"].in2)) or (dot_repeat_3f and (ch2 == self["prev-dot-repeatable-search"].in2))) then
        if new_search_3f then
          save_for({["dot-repeat"] = {["full-incl?"] = full_incl_3f, in1 = in1, in2 = ch2, in3 = labels[1]}, ["repeat"] = {in1 = in1, in2 = ch2}})
        end
        set_dot_repeat_if_applies()
        return jump_and_ignore_ch2_until_timeout_21(pos, full_incl_3f, new_search_3f, ch2)
      else
        if change_operation_3f() then
          handle_interrupted_change_op_21()
        end
        do
          echo_not_found((in1 .. ch2))
        end
        return nil
      end
    elseif (nil ~= _17_0) then
      local match_map = _17_0
      local shortcuts = get_shortcuts(match_map, labels, reverse_3f, jump_to_first_3f)
      if new_search_3f then
        if opts.grey_out_search_area then
          grey_out_search_area(reverse_3f)
        end
        do
          for ch2, positions in pairs(match_map) do
            local _let_1_ = positions
            local first = _let_1_[1]
            local rest = {(table.unpack or unpack)(_let_1_, 2)}
            if (jump_to_first_3f or empty_3f(rest)) then
              set_beacon_at(first, in1, ch2, {["init-round?"] = true, ["unlabeled?"] = true})
            end
            if not empty_3f(rest) then
              local positions_to_label
              if jump_to_first_3f then
                positions_to_label = rest
              else
                positions_to_label = positions
              end
              set_beacon_groups(ch2, positions_to_label, labels, shortcuts, {["init-round?"] = true})
            end
          end
        end
        highlight_cursor()
        vim.cmd("redraw")
      end
      local _20_0
      if repeat_3f then
        _20_0 = self["prev-search"].in2
      elseif dot_repeat_3f then
        _20_0 = self["prev-dot-repeatable-search"].in2
      else
        _20_0 = get_input_and_clean_up()
      end
      if (nil ~= _20_0) then
        local in2 = _20_0
        local _22_0
        if new_search_3f then
          _22_0 = shortcuts[in2]
        else
        _22_0 = nil
        end
        if ((type(_22_0) == "table") and (nil ~= (_22_0)[1]) and (nil ~= (_22_0)[2])) then
          local pos = (_22_0)[1]
          local ch2 = (_22_0)[2]
          if new_search_3f then
            save_for({["dot-repeat"] = {["full-incl?"] = full_incl_3f, in1 = in1, in2 = ch2, in3 = in2}, ["repeat"] = {in1 = in1, in2 = ch2}})
          end
          set_dot_repeat_if_applies()
          return jump_to_21(pos, full_incl_3f)
        elseif (_22_0 == nil) then
          if new_search_3f then
            save_for({["dot-repeat"] = {["full-incl?"] = full_incl_3f, in1 = in1, in2 = in2, in3 = labels[1]}, ["repeat"] = {in1 = in1, in2 = in2}})
          end
          local _25_0
          local function _26_()
            if change_operation_3f() then
              handle_interrupted_change_op_21()
            end
            do
              echo_not_found((in1 .. in2))
            end
            return nil
          end
          _25_0 = (match_map[in2] or _26_())
          if (nil ~= _25_0) then
            local positions = _25_0
            local _let_1_ = positions
            local first = _let_1_[1]
            local rest = {(table.unpack or unpack)(_let_1_, 2)}
            if (jump_to_first_3f or empty_3f(rest)) then
              set_dot_repeat_if_applies()
              jump_to_21(first, full_incl_3f)
              if jump_to_first_3f then
                force_statusline_update()
              end
            end
            if not empty_3f(rest) then
              local positions_to_label
              if jump_to_first_3f then
                positions_to_label = rest
              else
                positions_to_label = positions
              end
              if not (dot_repeat_3f and self["prev-dot-repeatable-search"].in3) then
                if opts.grey_out_search_area then
                  grey_out_search_area(reverse_3f)
                end
                do
                  set_beacon_groups(in2, positions_to_label, labels, shortcuts, {["repeat?"] = repeat_3f})
                end
                highlight_cursor()
                vim.cmd("redraw")
              end
              local loop_3f = true
              local group_offset = 0
              while loop_3f do
                local _30_0
                local _31_
                if dot_repeat_3f then
                  _31_ = self["prev-dot-repeatable-search"].in3
                else
                _31_ = nil
                end
                local function _33_()
                  loop_3f = false
                  return nil
                end
                _30_0 = (_31_ or get_input_and_clean_up() or _33_())
                if (nil ~= _30_0) then
                  local in3 = _30_0
                  if ((in3 == cycle_fwd_key) or (in3 == cycle_bwd_key)) then
                    local max_offset = math.floor((#positions_to_label / #labels))
                    local _35_
                    do
                      local _34_0 = in3
                      if (_34_0 == cycle_fwd_key) then
                        _35_ = inc
                      else
                        local _ = _34_0
                        _35_ = dec
                      end
                    end
                    group_offset = clamp(_35_(group_offset), 0, max_offset)
                    if opts.grey_out_search_area then
                      grey_out_search_area(reverse_3f)
                    end
                    do
                      set_beacon_groups(in2, positions_to_label, labels, shortcuts, {["group-offset"] = group_offset, ["repeat?"] = repeat_3f})
                    end
                    highlight_cursor()
                    vim.cmd("redraw")
                  elseif "else" then
                    loop_3f = false
                    if (dot_repeatable_op_3f and not dot_repeat_3f) then
                      if (group_offset == 0) then
                        self["prev-dot-repeatable-search"].in3 = in3
                      else
                        self["prev-dot-repeatable-search"].in3 = nil
                      end
                    end
                    local _35_0
                    local _37_
                    do
                      local _36_0 = label_indexes[in3]
                      if _36_0 then
                        local _38_0 = ((group_offset * #labels) + _36_0)
                        if _38_0 then
                          _37_ = positions_to_label[_38_0]
                        else
                          _37_ = _38_0
                        end
                      else
                        _37_ = _36_0
                      end
                    end
                    local function _38_()
                      if change_operation_3f() then
                        handle_interrupted_change_op_21()
                      end
                      do
                        if jump_to_first_3f then
                          vim.fn.feedkeys(in3)
                        end
                      end
                      return nil
                    end
                    _35_0 = (_37_ or _38_())
                    if (nil ~= _35_0) then
                      local pos = _35_0
                      set_dot_repeat_if_applies()
                      jump_to_21(pos, full_incl_3f)
                    end
                  end
                end
              end
              return nil
            end
          end
        end
      end
    end
  end
end
local plug_mappings = {{"n", "<Plug>Lightspeed_s", "s:to(false)"}, {"n", "<Plug>Lightspeed_S", "s:to(true)"}, {"x", "<Plug>Lightspeed_s", "s:to(false)"}, {"x", "<Plug>Lightspeed_S", "s:to(true)"}, {"o", "<Plug>Lightspeed_s", "s:to(false)"}, {"o", "<Plug>Lightspeed_S", "s:to(true)"}, {"o", "<Plug>Lightspeed_repeat_s", "s:to(false, true)"}, {"o", "<Plug>Lightspeed_repeat_S", "s:to(true, true)"}, {"n", "<Plug>Lightspeed_f", "ft:to(false, false)"}, {"n", "<Plug>Lightspeed_F", "ft:to(true, false)"}, {"n", "<Plug>Lightspeed_t", "ft:to(false, true)"}, {"n", "<Plug>Lightspeed_T", "ft:to(true, true)"}, {"x", "<Plug>Lightspeed_f", "ft:to(false, false)"}, {"x", "<Plug>Lightspeed_F", "ft:to(true, false)"}, {"x", "<Plug>Lightspeed_t", "ft:to(false, true)"}, {"x", "<Plug>Lightspeed_T", "ft:to(true, true)"}, {"o", "<Plug>Lightspeed_f", "ft:to(false, false)"}, {"o", "<Plug>Lightspeed_F", "ft:to(true, false)"}, {"o", "<Plug>Lightspeed_t", "ft:to(false, true)"}, {"o", "<Plug>Lightspeed_T", "ft:to(true, true)"}, {"o", "<Plug>Lightspeed_repeat_f", "ft:to(false, false, true)"}, {"o", "<Plug>Lightspeed_repeat_F", "ft:to(true, false, true)"}, {"o", "<Plug>Lightspeed_repeat_t", "ft:to(false, true, true)"}, {"o", "<Plug>Lightspeed_repeat_T", "ft:to(true, true, true)"}}
for _, _11_0 in ipairs(plug_mappings) do
  local _each_0_ = _11_0
  local mode = _each_0_[1]
  local lhs = _each_0_[2]
  local rhs_call = _each_0_[3]
  api.nvim_set_keymap(mode, lhs, ("<cmd>lua require'lightspeed'." .. rhs_call .. "<cr>"), {noremap = true, silent = true})
end
local function add_default_mappings()
  local default_mappings = {{"n", "s", "<Plug>Lightspeed_s"}, {"n", "S", "<Plug>Lightspeed_S"}, {"x", "z", "<Plug>Lightspeed_s"}, {"x", "Z", "<Plug>Lightspeed_S"}, {"o", "z", "<Plug>Lightspeed_s"}, {"o", "Z", "<Plug>Lightspeed_S"}, {"n", "f", "<Plug>Lightspeed_f"}, {"n", "F", "<Plug>Lightspeed_F"}, {"n", "t", "<Plug>Lightspeed_t"}, {"n", "T", "<Plug>Lightspeed_T"}, {"x", "f", "<Plug>Lightspeed_f"}, {"x", "F", "<Plug>Lightspeed_F"}, {"x", "t", "<Plug>Lightspeed_t"}, {"x", "T", "<Plug>Lightspeed_T"}, {"o", "f", "<Plug>Lightspeed_f"}, {"o", "F", "<Plug>Lightspeed_F"}, {"o", "t", "<Plug>Lightspeed_t"}, {"o", "T", "<Plug>Lightspeed_T"}}
  for _, _11_0 in ipairs(default_mappings) do
    local _each_0_ = _11_0
    local mode = _each_0_[1]
    local lhs = _each_0_[2]
    local rhs = _each_0_[3]
    if ((vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0)) then
      api.nvim_set_keymap(mode, lhs, rhs, {silent = true})
    end
  end
  return nil
end
add_default_mappings()
return {add_default_mappings = add_default_mappings, ft = ft, init_highlight = init_highlight, opts = opts, s = s, setup = setup}
