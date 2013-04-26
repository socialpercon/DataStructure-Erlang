-module(parse_opt).
-compile(export_all).
-include("process.hrl").

-define(MAX_RESTART_DEFAULT, 10).
parse_opt([]) ->
    MaxRoll = 20,
    MaxSize = 20,
    #processinfo{
        reference_key = "",
        pref_nodes = [],
        user = "",
        only_instance = false,
        loggeropt = [{max_roll, MaxRoll}, {max_size, MaxSize}],
        max_restart = ?MAX_RESTART_DEFAULT
    };
parse_opt([{refkey, Key} | Rest]) ->
    Proc = parse_opt(Rest),
    Proc#processinfo{reference_key = Key};
parse_opt([{node_names, Nodes} | Rest]) ->
    Proc = parse_opt(Rest),
    Proc#processinfo{pref_nodes = Nodes};
parse_opt([{username, Name} | Rest]) ->
    Proc = parse_opt(Rest),
    Proc#processinfo{user = Name};
parse_opt([{log_max_size, Size} | Rest]) ->
    Proc = parse_opt(Rest),
    Opt = Proc#processinfo.loggeropt,
    NewOpt = lists:keystore(max_size, 1, Opt, {max_size, Size}),
    Proc#processinfo{loggeropt = NewOpt};
parse_opt([{log_max_roll, Roll} | Rest]) ->
    Proc = parse_opt(Rest),
    Opt = Proc#processinfo.loggeropt,
    NewOpt = lists:keystore(max_roll, 1, Opt, {max_roll, Roll}),
    Proc#processinfo{loggeropt = NewOpt};
parse_opt([{max_restart, Count} | Rest]) ->
    Proc = parse_opt(Rest),
    Proc#processinfo{max_restart = Count};
parse_opt([{only_instance, Boolean} | Rest]) ->
    Proc = parse_opt(Rest),
    Proc#processinfo{only_instance = Boolean};
parse_opt([X | _]) ->
    {error, X}.
