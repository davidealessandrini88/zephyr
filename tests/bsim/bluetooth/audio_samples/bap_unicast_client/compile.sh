#!/usr/bin/env bash
# Copyright 2023 Nordic Semiconductor ASA
# SPDX-License-Identifier: Apache-2.0

#set -x #uncomment this line for debugging
set -ue

: "${ZEPHYR_BASE:?ZEPHYR_BASE must be set to point to the zephyr root directory}"

source ${ZEPHYR_BASE}/tests/bsim/compile.source

if [ "${BOARD_TS}" == "nrf5340bsim_nrf5340_cpuapp" ]; then
  app=samples/bluetooth/bap_unicast_server sysbuild=1 compile
  app=tests/bsim/bluetooth/audio_samples/bap_unicast_client \
    sample=${ZEPHYR_BASE}/samples/bluetooth/bap_unicast_client \
    conf_file=${sample}/prj.conf \
    conf_overlay=${sample}/boards/nrf5340_audio_dk_nrf5340_cpuapp.conf \
    exe_name=bs_${BOARD_TS}_${app}_prj_conf sysbuild=1 compile
else
  app=samples/bluetooth/bap_unicast_server conf_overlay=overlay-bt_ll_sw_split.conf \
    exe_name=bs_${BOARD_TS}_${app}_prj_conf sysbuild=1 compile
  app=tests/bsim/bluetooth/audio_samples/bap_unicast_client \
    sample=${ZEPHYR_BASE}/samples/bluetooth/bap_unicast_client \
    conf_file=${sample}/prj.conf \
    conf_overlay=${sample}/overlay-bt_ll_sw_split.conf \
    exe_name=bs_${BOARD_TS}_${app}_prj_conf sysbuild=1 compile
fi

wait_for_background_jobs
