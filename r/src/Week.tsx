import React from 'react';
import {Actions, ActionsProps, CalendarWeek, DayOfWeek, Month} from './Types';
import {Button} from './Inputs';

type Props = ActionsProps & {
  month: Month
  week: CalendarWeek
}

const dayOfWeekNumbers = Object.keys(DayOfWeek).map(dow => Number(dow)).filter(dow => !isNaN(dow))

function Week(props: Props) {
  return (
    <div className="row week">
      <div className="col controls">
        <Button action={() => props.actions.skip(Object.values(props.week))}>
          skip
        </Button>
        <Button action={() => props.actions.unskip(Object.values(props.week))}>
          unskip
        </Button>
      </div>
      {dayOfWeekNumbers.map(dow => renderDay(props.week[dow as number], props.actions))}
    </div>
  )
}

function renderDay(day: null | Date, actions: Actions) {
  if (day) {
    return (
      <div className="col day">
        <div className="dayNum">{day.getDate()}</div>
        <Button action={() => actions.skip([day])}>skip</Button>
        <Button action={() => actions.unskip([day])}>unskip</Button>
      </div>
    )
  } else {
    return <div className="col"></div>
  }
}

export default Week
