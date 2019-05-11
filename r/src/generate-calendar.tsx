import {MonthData, WeekData} from './Types';

export default function generateCalendar(start: Date): Array<MonthData> {
  return generateMonths(start, [])
}

function generateMonths(date: Date, res: Array<MonthData>): Array<MonthData> {
  const {nextDate, month} = generateMonth(date)
  res.push(month)
  if (nextDate.getFullYear() !== date.getFullYear())
    return res
  return generateMonths(nextDate, res)
}

const MONTH_NAME = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

function generateMonth(date: Date): {nextDate: Date, month: MonthData} {
  const {nextDate, weeks} = generateWeeks(date, [])
  const month = {month: MONTH_NAME[date.getMonth()], weeks}
  return {nextDate, month}
}

function generateWeeks(date: Date, weeks: Array<WeekData>): {nextDate: Date, weeks: Array<WeekData>} {
  const {nextDate, week} = generateWeek(date)
  weeks.push(week)
  if (nextDate.getMonth() !== date.getMonth())
    return {nextDate, weeks}
  return generateWeeks(nextDate, weeks)
}

function generateWeek(date: Date): {nextDate: Date, week: WeekData} {
  const week = []
  let i = 0
  for (; i < date.getDay(); i++) {
    week.push(null)
  }
  let nextDate = date
  for (; i < 7 && nextDate.getMonth() === date.getMonth(); i++) {
    week.push({
      day: nextDate.getDate(),
      dow: nextDate.getDay(),
      skipped: false
    })
    nextDate = addDays(nextDate, 1)
  }
  for (; i < 7; i++) {
    week.push(null)
  }
  return {nextDate, week}
}

function addDays(date: Date, offset: number): Date {
  const newDate = new Date(date.valueOf())
  newDate.setDate(date.getDate() + offset)
  return newDate
}
