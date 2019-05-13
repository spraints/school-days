export enum DayOfWeek {
  Sunday = 0,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}

export type DayData = {
  day: number
  dow: DayOfWeek
  skipped: boolean
}

export type WeekData = Array<null | DayData>

export type MonthData = {
  month: string
  weeks: Array<WeekData>
};

export type MonthDay = {
  month: string
  day: number
}

export type Actions = {
  onSkip: (days: Array<MonthDay>) => void
  onUnskip: (days: Array<MonthDay>) => void
  setCompletedDays: (days: number) => void
  setRequiredDays: (days: number) => void
}

export type ActionsProps = {
  actions: Actions
}
