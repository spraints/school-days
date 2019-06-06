import React from 'react';
import Week from './Week';
import {ActionsProps, Month} from './Types';
import {SchoolMonth} from './school-calendar';

type Props = ActionsProps & SchoolMonth

function MonthElement(props: Props) {
  return (
    <div className="month">
      <div className="row">
        <div className="col-md-8 month-name">{Month[props.month]}</div>
      </div>
      <div className="row day-names d-none d-md-flex">
        <div className="col-md-1"></div>
        <div className="col-md-1 day-name">Sun</div>
        <div className="col-md-1 day-name">Mon</div>
        <div className="col-md-1 day-name">Tues</div>
        <div className="col-md-1 day-name">Weds</div>
        <div className="col-md-1 day-name">Thur</div>
        <div className="col-md-1 day-name">Fri</div>
        <div className="col-md-1 day-name">Sat</div>
      </div>
      {props.weeks.map(week => <Week month={props.month} week={week} actions={props.actions} />)}
    </div>
  )
}

export default MonthElement;
