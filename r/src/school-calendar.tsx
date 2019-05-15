import {AppState, CalendarMonth, CalendarWeek, Month} from './Types'

export type SchoolCalendar = Array<SchoolMonth>

export type SchoolMonth = {
  month: Month
  weeks: Array<SchoolWeek>
}

export enum SchoolDayType {
  School,
  Holiday,
  Weekend
}

export type SchoolWeek = { [dayOfWeek: number]: SchoolDay }

export type SchoolDay = {
  date: Date
  sdType: SchoolDayType
  schoolDayNumber: number
}

export function assembleSchoolCalendar(state: AppState): SchoolCalendar {
  return state.calendar.map(month => assembleMonth(month, state))
}

function assembleMonth(month: CalendarMonth, state: AppState): SchoolMonth {
  return {month: month.month, weeks: month.weeks.map(week => assembleWeek(week, state))}
}

function assembleWeek(week: CalendarWeek, state: AppState): SchoolWeek {
  const ret: SchoolWeek = {}
  for (const dow in week) {
    ret[dow] = {
      date: week[dow],
      sdType: SchoolDayType.School,
      schoolDayNumber: 150
    }
  }
  return ret
}
