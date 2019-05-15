import React from 'react';
import Week from './Week';
import {ActionsProps} from './Types';
import {SchoolMonth} from './school-calendar';

type Props = ActionsProps & SchoolMonth

function Month(props: Props) {
  return (
    <div className="month">
      <div className="row">
        <div className="col month-name">{props.month}</div>
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
      {props.weeks.map(week => <Week month={props.month} week={week} actions={props.actions} />)}
    </div>
  )
}

export default Month;
