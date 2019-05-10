import React from 'react';
import Month from './Month';
import {MonthData} from './Types';

type Props = {
  months: Array<MonthData>
}

function Calendar(props: Props) {
  return (
    <div>
      {props.months.map(month => <Month name={month.month} weeks={month.weeks} />)}
    </div>
  )
}

export default Calendar;
