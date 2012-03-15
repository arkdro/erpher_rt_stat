%%%
%%% erpher_rt_stat_conf: functions for config
%%%
%%% Copyright (c) 2011 Megaplan Ltd. (Russia)
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"),
%%% to deal in the Software without restriction, including without limitation
%%% the rights to use, copy, modify, merge, publish, distribute, sublicense,
%%% and/or sell copies of the Software, and to permit persons to whom
%%% the Software is furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included
%%% in all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%%% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
%%% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
%%% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
%%% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
%%% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
%%% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%
%%% @author arkdro <arkdro@gmail.com>
%%% @since 2012-03-15 14:02
%%% @license MIT
%%% @doc functions related to config file read, config processing
%%%

-module(erpher_rt_stat_conf).

%%%----------------------------------------------------------------------------
%%% Exports
%%%----------------------------------------------------------------------------

-export([get_config_stat/0]).

%%%----------------------------------------------------------------------------
%%% Includes
%%%----------------------------------------------------------------------------

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-include("estat.hrl").

%%%----------------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------------
%%
%% @doc reads config file for stat, fills in est record with configured
%% values
%% @since 2011-12-20 13:19
%%
-spec get_config_stat() -> #est{}.

get_config_stat() ->
    List = get_config_list(),
    fill_config_stat(List).

%%%----------------------------------------------------------------------------
%%% Internal functions
%%%----------------------------------------------------------------------------
%%
%% @doc fetches the configuration from environment
%% @since 2011-08-01 17:01
%%
-spec get_config_list() -> list().

get_config_list() ->
    application:get_all_env('erpher_rt_stat').

%%-----------------------------------------------------------------------------
%%
%% @doc gets data from the list of key-value tuples and stores it into
%% ejr record
%% @since 2011-12-20 13:22
%%
-spec fill_config_stat(list()) -> #est{}.

fill_config_stat(All_list) ->
    List = proplists:get_value(estat, All_list, []),
    #est{
        % amount and time for last jobs
        stat_limit_n = proplists:get_value(stat_limit_n, List, ?STAT_LIMIT_N),
        stat_limit_t = proplists:get_value(stat_limit_t, List, ?STAT_LIMIT_T),
        % time limit for working/queued counters
        stat_limit_cnt_h = proplists:get_value(stat_limit_cnt_h, List,
                                             ?STAT_LIMIT_CT_H),
        stat_limit_cnt_m = proplists:get_value(stat_limit_cnt_m, List,
                                             ?STAT_LIMIT_CT_M),

        log_procs_interval = proplists:get_value(log_procs_interval, List,
                                                 ?LOG_PROCS_INTERVAL),
        rt_info_file = proplists:get_value(rt_info_file, List),
        rotate_interval = proplists:get_value(rotate_interval, List, 'hour'),
        debug = proplists:get_value(debug, List, []),
        storage_base = proplists:get_value(storage_base, List, ?STAT_STORAGE),
        keep_time = proplists:get_value(keep_time, List, ?STAT_KEEP_TIME),
        flush_interval = proplists:get_value(flush_interval, List,
                                             ?STAT_FLUSH_INTERVAL),
        flush_number = proplists:get_value(flush_number, List,
                                             ?STAT_FLUSH_NUMBER)
    }.

%%-----------------------------------------------------------------------------
