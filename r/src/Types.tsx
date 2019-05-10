export type DayData = {
  day: number
  skipped: boolean
}

export type WeekData = Array<null | DayData>

export type MonthData = {
  month: string
  weeks: Array<WeekData>
};
