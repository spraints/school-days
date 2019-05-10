import React from 'react';
import {WeekData, DayData} from './Types';

type Props = {
  days: WeekData
}

function Week(props: Props) {
  return (
    <div className="row">
      <div className="col controls">(todo skip/unskip whole week)</div>
      {props.days.map(renderDay)}
    </div>
  )
}

function renderDay(day: null | DayData) {
  if (day == null) {
    return <div className="col"></div>
  } else {
    return <div className="col">yo</div>
  }
}

export default Week
