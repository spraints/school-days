import React from 'react';
import {Actions, ActionsProps, DayOfWeek, Month} from './Types';
import {Button} from './Inputs';
import {SchoolDay, SchoolDayType, SchoolWeek} from './school-calendar'

type Props = ActionsProps & {
  month: Month
  week: SchoolWeek
}

const dayOfWeekNumbers = Object.keys(DayOfWeek).map(dow => Number(dow)).filter(dow => !isNaN(dow))

function Week(props: Props) {
  return (
    <div className="row week">
      <div className="col controls">
        <Button action={() => props.actions.skip(days(props.week))}>
          skip
        </Button>
        <Button action={() => props.actions.unskip(days(props.week))}>
          unskip
        </Button>
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
      <div className={"col day "+ SchoolDayType[day.sdType]}>
        <div className="dayNum">{day.date.getDate()}</div>
        {day.schoolDayNumber !== undefined && <div>#{day.schoolDayNumber}</div>}
        <Button action={() => actions.skip([day.date])}>skip</Button>
        <Button action={() => actions.unskip([day.date])}>unskip</Button>
      </div>
    )
  } else {
    return <div className="col"></div>
  }
}

export default Week
