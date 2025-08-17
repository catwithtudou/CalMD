#!/bin/bash

# 显示开始信息
echo "🗓️  正在导出日历..."

# 默认值
DAYS_FROM_TODAY=${1:-0}
DAY_RANGE=${2:-1}
CALENDAR_BLACKLIST=${3:-"生日,节假日,垃圾邮件,个人隐私"}

# 将逗号分隔的字符串转换为AppleScript列表格式
IFS=',' read -ra BLACKLIST_ARRAY <<< "$CALENDAR_BLACKLIST"
APPLESCRIPT_BLACKLIST="{"
for i in "${!BLACKLIST_ARRAY[@]}"; do
    if [ $i -gt 0 ]; then
        APPLESCRIPT_BLACKLIST="$APPLESCRIPT_BLACKLIST, "
    fi
    APPLESCRIPT_BLACKLIST="$APPLESCRIPT_BLACKLIST\"${BLACKLIST_ARRAY[i]}\""
done
APPLESCRIPT_BLACKLIST="$APPLESCRIPT_BLACKLIST}"

osascript << EOF

-- 设置时间范围
set daysFromToday to $DAYS_FROM_TODAY -- 0表示今天，1表示明天，-1表示昨天
set dayRange to $DAY_RANGE -- 1表示1天，7表示一周

-- 黑名单设置：不想导出的日历名称
set calendarBlacklist to $APPLESCRIPT_BLACKLIST

-- 计算开始和结束日期
set startDate to current date
set time of startDate to 0
set startDate to startDate + (daysFromToday * 24 * 60 * 60)
set endDate to startDate + (dayRange * 24 * 60 * 60)

-- 准备用于存储所有事件信息的列表（包含事件和日历名称）
set allEventInfo to {}

-- 告诉"日历"应用去执行操作
tell application "Calendar"
	-- 获取所有日历
	set allCalendars to every calendar

	-- 遍历每个日历，收集指定时间范围的所有事件
	repeat with aCalendar in allCalendars
		-- 获取日历名称
		set calendarName to name of aCalendar

		-- 检查日历是否在黑名单中
		set isBlacklisted to false
		repeat with blacklistedName in calendarBlacklist
			if calendarName contains blacklistedName then
				set isBlacklisted to true
				exit repeat
			end if
		end repeat

		-- 如果不在黑名单中，才处理这个日历
		if not isBlacklisted then
			-- 获取当前日历中指定时间范围的所有事件
			set rangeEvents to (every event of aCalendar whose start date is greater than or equal to startDate and start date is less than endDate)

			-- 将这些事件和日历名称一起添加到总列表中
			repeat with anEvent in rangeEvents
				-- 创建一个包含事件和日历名称的记录
				set eventInfo to {eventRef:anEvent, calendarName:calendarName}
				set end of allEventInfo to eventInfo
			end repeat
		end if
	end repeat
end tell

-- 对所有事件按开始时间进行排序
set eventCount to count of allEventInfo
repeat with i from 1 to (eventCount - 1)
	repeat with j from 1 to (eventCount - i)
		tell application "Calendar"
			set event1StartDate to start date of (eventRef of item j of allEventInfo)
			set event2StartDate to start date of (eventRef of item (j + 1) of allEventInfo)

			-- 如果当前事件的开始时间晚于下一个事件，则交换位置
			if event1StartDate > event2StartDate then
				set tempEventInfo to item j of allEventInfo
				set item j of allEventInfo to item (j + 1) of allEventInfo
				set item (j + 1) of allEventInfo to tempEventInfo
			end if
		end tell
	end repeat
end repeat

-- 函数：格式化时间为 HH:MM 格式
on formatTimeToMinutes(timeString)
	set timeItems to my splitString(timeString, ":")
	if (count of timeItems) ≥ 2 then
		return (item 1 of timeItems) & ":" & (item 2 of timeItems)
	else
		return timeString
	end if
end formatTimeToMinutes

-- 函数：分割字符串
on splitString(theString, theDelimiter)
	set oldDelimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to theDelimiter
	set theArray to every text item of theString
	set AppleScript's text item delimiters to oldDelimiters
	return theArray
end splitString

-- 函数：格式化日期为完整格式
on formatDate(dateObj)
	set weekdayNames to {"周日", "周一", "周二", "周三", "周四", "周五", "周六"}

	set yearNum to year of dateObj
	set monthNum to month of dateObj as integer
	set dayNum to day of dateObj
	set dayOfWeek to weekday of dateObj as integer

	return (yearNum as string) & "年" & (monthNum as string) & "月" & (dayNum as string) & "日" & (item dayOfWeek of weekdayNames)
end formatDate

-- 函数：填充字符串到指定长度
on padString(str, targetLength)
	set currentLength to length of str
	if currentLength ≥ targetLength then
		return str
	else
		set paddingLength to targetLength - currentLength
		set padding to ""
		repeat paddingLength times
			set padding to padding & " "
		end repeat
		return str & padding
	end if
end padString

-- 第一次遍历：找出最长的日历名称长度
set maxCalendarNameLength to 0
tell application "Calendar"
	repeat with eventInfo in allEventInfo
		set calendarName to calendarName of eventInfo
		set nameLength to length of calendarName
		if nameLength > maxCalendarNameLength then
			set maxCalendarNameLength to nameLength
		end if
	end repeat
end tell

-- 准备用于存储 Markdown 文本的列表
set markdownLines to {}
set lastEventDate to ""

-- 遍历排序后的事件列表，生成 Markdown
tell application "Calendar"
	repeat with eventInfo in allEventInfo
		-- 获取事件引用和日历名称
		set anEvent to eventRef of eventInfo
		set calendarName to calendarName of eventInfo

		-- 先获取日期对象，然后格式化时间
		set eventStartDate to start date of anEvent
		set eventEndDate to end date of anEvent
		set startTimeRaw to time string of eventStartDate
		set endTimeRaw to time string of eventEndDate

		-- 格式化时间，去掉秒数
		set startTime to my formatTimeToMinutes(startTimeRaw)
		set endTime to my formatTimeToMinutes(endTimeRaw)

		-- 格式化日期
		set eventDateString to my formatDate(eventStartDate)

		-- 如果是新的一天，添加日期标题
		if eventDateString ≠ lastEventDate then
			if lastEventDate ≠ "" then
				-- 不是第一个日期，先添加空行
				set end of markdownLines to ""
			end if
			set end of markdownLines to "**" & eventDateString & "**："
			set end of markdownLines to ""
			set lastEventDate to eventDateString
		end if

		-- 获取事件标题
		set eventTitle to summary of anEvent

		-- 填充日历名称以保持对齐
		set paddedCalendarName to my padString(calendarName, maxCalendarNameLength)

		-- 拼接成 Markdown 格式的单行
		set markdownLine to "-   **" & startTime & " - " & endTime & "** \`[" & paddedCalendarName & "]\`：" & eventTitle

		-- 将该行添加到列表中
		set end of markdownLines to markdownLine
	end repeat
end tell

-- 使用换行符将所有行合并成一个文本块
set {oldTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, return}
set finalMarkdown to markdownLines as text
set AppleScript's text item delimiters to oldTID

-- 将最终的文本拷贝到剪贴板
set the clipboard to finalMarkdown

-- 生成通知消息
if daysFromToday = 0 and dayRange = 1 then
	set notificationMessage to "今日所有日程已成功导出到剪贴板！"
else
	set notificationMessage to "指定时间范围的日程已成功导出到剪贴板！"
end if

-- 显示一个完成通知
display notification notificationMessage with title "任务完成"
EOF

# 显示结束信息
echo "🗓️  已导出日历到剪贴板"