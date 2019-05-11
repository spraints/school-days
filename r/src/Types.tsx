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
