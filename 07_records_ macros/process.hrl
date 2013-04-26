-define(PINFO_FIELD, { cid,
                       handler,
                       host,
                       only_instance,
                       respawn_count,
                       max_restart,
                       pref_nodes,
                       user,
                       cpu,
                       memory,
                       start_time,
                       last_event,
		       type,
                       scriptname,
                       progname,
                       user_param,
                       reference_key,
                       data_hash,
                       port_dict,
                       os_pid,
                       loggeropt,
                       state,
                       exit_reason}).

-record(processinfo, ?PINFO_FIELD).

-define(PROCESS_TYPE_DAEMON,    0).
-define(PROCESS_TYPE_TASK,      1).
-define(PROCESS_TYPE_MAPREDUCE, 2).

-define(PROCESS_STATE_LOADING, loading).
-define(PROCESS_STATE_INIT, init).
-define(PROCESS_STATE_READY, ready).
-define(PROCESS_STATE_SHTDOWN, shutdown).
-define(PROCESS_STATE_KILLED, killed).
-define(PROCESS_STATE_MOVING, moving).
-define(PROCESS_STATE_EXITED, exited).
