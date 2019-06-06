import {AppState, CalendarMonth, CalendarWeek, DayOfWeek, Month, Skip} from './Types'

export type SchoolCalendar = Array<SchoolMonth>

export type SchoolMonth = {
  month: Month
  weeks: Array<SchoolWeek>
}

export enum SchoolDayType {
  School,
  Break,    // a day off in the middle of the school year.
  Vacation, // school year is finished!
  Weekend
}

export type SchoolWeek = { [dayOfWeek: number]: SchoolDay }

export type SchoolDay = {
  date: Date
  sdType: SchoolDayType
  schoolDayNumber?: number
}

type FastSkips = { [dayHash: number]: boolean }

type InternalState = {
  skips: FastSkips
  requiredDays: number
  completedDays: number
}

export function assembleSchoolCalendar(state: AppState): SchoolCalendar {
  let intState = {
    skips: transformSkips(state.skips),
    requiredDays: state.requiredDays,
    completedDays: state.completedDays
  }
  const result = []
  for (const month of state.calendar) {
    const res = assembleMonth(month, intState)
    result.push(res.month)
    intState = res.state
  }
  return result
}

function assembleMonth(month: CalendarMonth, state: InternalState): {month: SchoolMonth, state: InternalState} {
  const schoolMonth = {month: month.month, weeks: [] as Array<SchoolWeek>}
  for (const week of month.weeks) {
    const res = assembleWeek(week, state)
    schoolMonth.weeks.push(res.week)
    state = res.state
  }
  return {month: schoolMonth, state}
}

function assembleWeek(week: CalendarWeek, state: InternalState): {week: SchoolWeek, state: InternalState} {
  const ret: SchoolWeek = {}
  for (const dow in week) {
    if (parseInt(dow) === DayOfWeek.Sunday || parseInt(dow) === DayOfWeek.Saturday) {
      ret[dow] = {
        date: week[dow],
        sdType: SchoolDayType.Weekend
      }
    } else if (state.completedDays >= state.requiredDays) {
      ret[dow] = {
        date: week[dow],
        sdType: SchoolDayType.Vacation
      }
    } else if (state.skips[idx(week[dow].getMonth(), week[dow].getDate())]) {
      ret[dow] = {
        date: week[dow],
        sdType: SchoolDayType.Break
      }
    } else {
      ret[dow] = {
        date: week[dow],
        sdType: SchoolDayType.School,
        schoolDayNumber: state.completedDays + 1
      }
      state.completedDays++
    }
  }
  return {week: ret, state}
}

function transformSkips(skips: Array<Skip>): FastSkips {
  const res = {} as FastSkips
  for (const skip of skips) {
    res[idx(skip.month, skip.day)] = true
  }
  return res
}

function idx(month: number, day: number): number {
  return month * 40 + day
}
