import React from 'react';
import {Actions, ActionsProps, DayOfWeek, Month} from './Types';
import {SkipButton, UnskipButton} from './Inputs';
import {SchoolDay, SchoolDayType, SchoolWeek} from './school-calendar'

type Props = ActionsProps & {
  month: Month
  week: SchoolWeek
}

const dayOfWeekNumbers = Object.keys(DayOfWeek).map(dow => Number(dow)).filter(dow => !isNaN(dow))

function Week(props: Props) {
  return (
    <div className="row week">
      <div className="col-md-1 controls">
        <SkipButton action={() => props.actions.skip(days(props.week))} />
        <UnskipButton action={() => props.actions.unskip(days(props.week))} />
      </div>
      {dayOfWeekNumbers.map(dow => renderDay(props.week[dow as number], props.actions))}
    </div>
  )
}

function days(week: SchoolWeek): Array<Date> {
  return Object.values(week).map(day => day.date)
}

function renderDay(day: null | SchoolDay, actions: Actions) {
  if (day) {
    return (
      <div className={"col-md-1 day "+ SchoolDayType[day.sdType]}>
        <p>
          <span className="day-name d-md-none">{DayOfWeek[day.date.getDay()]} </span>
          <span className="day-date">{day.date.getDate()} </span>
          {day.schoolDayNumber !== undefined && <span className="day-schooldaynum">#{day.schoolDayNumber}</span>}
        </p>
        <DayAction day={day} actions={actions} />
      </div>
    )
  } else {
    return <div className="col-md-1"></div>
  }
}

function DayAction(props: {day: SchoolDay, actions: Actions}) {
  const {day, actions} = props
  if (day.sdType === SchoolDayType.School) {
    return <SkipButton action={() => actions.skip([day.date])} />
  } else if (day.sdType === SchoolDayType.Break) {
    return <UnskipButton action={() => actions.unskip([day.date])} />
  } else {
    return <div></div>
  }
}

export default Week
