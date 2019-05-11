import {MonthData, DayOfWeek} from './Types';

export default function generateCalendar(): Array<MonthData> {
  return [
    {month: "May", weeks: [
      [
        null,
        null,
        null,
        {day: 1, skipped: false, dow: DayOfWeek.Wednesday},
        {day: 2, skipped: false, dow: DayOfWeek.Thursday},
        {day: 3, skipped: false, dow: DayOfWeek.Friday},
        {day: 4, skipped: false, dow: DayOfWeek.Saturday},
      ],
      [
        {day: 5, skipped: false, dow: DayOfWeek.Sunday},
        {day: 6, skipped: false, dow: DayOfWeek.Monday},
        {day: 7, skipped: false, dow: DayOfWeek.Tuesday},
        {day: 8, skipped: false, dow: DayOfWeek.Wednesday},
        {day: 9, skipped: false, dow: DayOfWeek.Thursday},
        {day: 10, skipped: false, dow: DayOfWeek.Friday},
        {day: 11, skipped: false, dow: DayOfWeek.Saturday},
      ],
      [
        {day: 12, skipped: false, dow: DayOfWeek.Sunday},
        {day: 13, skipped: false, dow: DayOfWeek.Monday},
        {day: 14, skipped: true, dow: DayOfWeek.Tuesday},
        {day: 15, skipped: false, dow: DayOfWeek.Wednesday},
        {day: 16, skipped: false, dow: DayOfWeek.Thursday},
        {day: 17, skipped: false, dow: DayOfWeek.Friday},
        {day: 18, skipped: false, dow: DayOfWeek.Saturday},
      ],
    ]}
  ];
}
