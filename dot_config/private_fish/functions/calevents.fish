function calevents --description "Get upcoming calendar events"
    # Check if we're on macOS and icalbuddy is available
    if test (uname) != "Darwin"
        echo "Error: calevents only works on macOS."
        return 1
    end

    if not command -v icalbuddy >/dev/null 2>&1
        echo "Error: icalbuddy not found. Install it with: brew install ical-buddy"
        return 1
    end

    set -l days $argv[1]
    if test -z "$days"
        set days 7
    end

    set -l full_days (math $days - 1)
    set -l day_word "days"
    if test $days -eq 1
        set day_word "day"
    end

    begin
        echo -n "Today is "(date "+%A, %B %-d, %Y")". Events for the next $days $day_word:"
        echo
        icalbuddy -nc -ic "Personal,Home,Calendar" -sd -npn -nrd -b "" -po "datetime,title" -eep "notes,attendees,location,url,calendar" eventsToday+$full_days
    end | sed -e 's/^------------------------$//' -e 's/^    //' | awk '
        BEGIN {
          skip_patterns[++s] = "(Sr|Senior) Staff"
          skip_patterns[++s] = "Coffee Time"
        }

        function should_skip(text) {
          for (i in skip_patterns) {
            if (text ~ skip_patterns[i]) return 1
          }
          return 0
        }

        function format_date(date) {
          split(date, parts, " ")
          month = parts[1]
          day = parts[2]
          sub(/,/, "", day)
          year = parts[3]

          cmd = sprintf("date -j -f \"%%b %%d %%Y\" \"%s %s %s\" \"+%%A, %%B %%d, %%Y\"", month, day, year)
          cmd | getline formatted
          close(cmd)
          return formatted
        }

        /^Today/ { print; next }
        /^[A-Za-z]/ && /:$/ {
          if (NR > 1) printf "\n"
          date=$0
          sub(/:$/, "", date)
          printf "%s\n", format_date(date)
          delete seen
          next
        }
        /^[0-9]/ {
          time=$0
          getline title
          event = time ": " title
          if (!should_skip(title) && !(event in seen)) {
            print event
            seen[event] = 1
          }
          next
        }
        /^[^ ]/ && !/^$/ && !/^Failed/ && !/^date:/ && !/^usage:/ {
          if (!should_skip($0) && !seen[$0]) {
            print "(All day) " $0
            seen[$0] = 1
          }
        }'
end
