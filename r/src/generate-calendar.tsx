import {CalendarMonth, CalendarWeek, DayOfWeek, Month} from './Types';

export default function generateCalendar(start: Date): Array<CalendarMonth> {
  const days = generateDays(start)
  return collectMonths(days)
}

function generateDays(start: Date): Array<Date> {
  const result = []
  for (let date = start; date.getFullYear() === start.getFullYear(); date = addDays(date, 1)) {
    result.push(date)
  }
  return result
}

function collectMonths(days: Array<Date>): Array<CalendarMonth> {
  if (days.length === 0) return []
  const result: Array<CalendarMonth> = []
  let currentMonth: null | CalendarMonth = null
  let currentWeek = {} as CalendarWeek
  for (const day of days) {
    let month: Month = day.getMonth()
    let dow: DayOfWeek = day.getDay()
    if (currentMonth === null || currentMonth.month !== month) {
      currentWeek = {}
      currentMonth = {month, weeks: [currentWeek]}
      result.push(currentMonth)
    } else if (dow === DayOfWeek.Sunday) {
      currentWeek = {}
      currentMonth.weeks.push(currentWeek)
    }
    currentWeek[dow] = day
  }
  return result
}

function addDays(date: Date, offset: number): Date {
  const newDate = new Date(date.valueOf())
  newDate.setDate(date.getDate() + offset)
  return newDate
}
