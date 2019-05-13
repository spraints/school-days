import React from 'react';
import Month from './Month';
import {MonthData, ActionsProps} from './Types';

type Props = ActionsProps & {
  months: Array<MonthData>
}

function Calendar(props: Props) {
  return (
    <div className="calendar">
      {props.months.map(month => <Month name={month.month} weeks={month.weeks} actions={props.actions} />)}
    </div>
  )
}

export default Calendar;
