#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

get_ratio()
{
  case $(uname -s) in
    Linux)
      usage_gb=$(free -m | awk 'NR==2 {printf "%.1f", $3/1024}')
      echo "$usage_gb"
      ;;

    Darwin)
      used_mem=$(vm_stat | grep ' active\|wired\|compressor\|speculative' | sed 's/[^0-9]//g' | paste -sd ' ' - | awk -v pagesize=$(pagesize) '{printf "%.1f\n", ($1+$2+$3+$5) * pagesize / 1048576 / 1024}')
      echo "$used_mem"
      ;;

    FreeBSD)
      hw_pagesize="$(sysctl -n hw.pagesize)"
      mem_inactive="$(($(sysctl -n vm.stats.vm.v_inactive_count) * hw_pagesize))"
      mem_unused="$(($(sysctl -n vm.stats.vm.v_free_count) * hw_pagesize))"
      mem_cache="$(($(sysctl -n vm.stats.vm.v_cache_count) * hw_pagesize))"

      free_mem=$(((mem_inactive + mem_unused + mem_cache) / 1024 / 1024))
      total_mem=$(($(sysctl -n hw.physmem) / 1024 / 1024))
      used_mem=$((total_mem - free_mem))
      memory=$(echo "scale=1; $used_mem/1024" | bc)
      echo "$memory"
      ;;

    OpenBSD)
      hw_pagesize="$(pagesize)"
      used_mem=$(( (
$(vmstat -s | grep "pages active$" | sed -ne 's/^ *\([0-9]*\).*$/\1/p') +
$(vmstat -s | grep "pages inactive$" | sed -ne 's/^ *\([0-9]*\).*$/\1/p') +
$(vmstat -s | grep "pages wired$" | sed -ne 's/^ *\([0-9]*\).*$/\1/p') +
$(vmstat -s | grep "pages zeroed$" | sed -ne 's/^ *\([0-9]*\).*$/\1/p') +
0) * hw_pagesize / 1024 / 1024 ))
      memory=$(echo "scale=1; $used_mem/1024" | bc)
      echo "$memory"
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # TODO - windows compatability
      ;;
  esac
}

main()
{
  ram_label=$(get_tmux_option "@dracula-ram-usage-label" "RAM")
  ram_ratio=$(get_ratio)
  echo "$ram_label $ram_ratio"
}

#run main driver
main
