import React from 'react';
import Month from './Month';
import {ActionsProps, CalendarMonth} from './Types';

type Props = ActionsProps & {
  months: Array<CalendarMonth>
}

function Calendar(props: Props) {
  return (
    <div className="calendar">
      {props.months.map(month =>
        <Month actions={props.actions} {...month} />
      )}
    </div>
  )
}

export default Calendar;
