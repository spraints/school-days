export type CalendarMonth = {
  month: Month
  weeks: Array<CalendarWeek>
}

export type CalendarWeek = { [id: number]: Date }

export enum DayOfWeek {
  Sunday = 0,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}

export enum Month {
  January = 0,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December
}

export type Actions = {
  skip: (days: Array<Date>) => void
  unskip: (days: Array<Date>) => void
  setCompletedDays: (days: number) => void
  setRequiredDays: (days: number) => void
}

export type ActionsProps = {
  actions: Actions
}
