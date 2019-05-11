import React from 'react';
import Week from './Week';
import {WeekData} from './Types';

type Props = {
  name: string
  weeks: Array<WeekData>
}

function Month(props: Props) {
  return (
    <div className="month">
      <div className="row">
        <div className="col month-name">{props.name}</div>
      </div>
      <div className="row day-names">
        <div className="col"></div>
        <div className="col day-name">Sun</div>
        <div className="col day-name">Mon</div>
        <div className="col day-name">Tues</div>
        <div className="col day-name">Weds</div>
        <div className="col day-name">Thur</div>
        <div className="col day-name">Fri</div>
        <div className="col day-name">Sat</div>
      </div>
      {props.weeks.map(week => <Week days={week} />)}
    </div>
  )
}

export default Month;
