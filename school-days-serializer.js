(function(exports) {
  exports.saveSchoolDays = data => {
    console.log(data)
    saveInt(data, "finished")
    saveInt(data, "required")
  }

  exports.loadSchoolDays = () => {
    console.log("todo - read from local storage")
    var data = {finished: 0, required: 180, skips: [], start: null}
    loadInt(data, "finished")
    loadInt(data, "required")
    return data
  }

  function loadInt(data, field) {
    var stored = localStorage.getItem(lsname(field))
    var n = parseInt(stored)
    if (!isNaN(n)) {
      data[field] = n
    }
  }

  function saveInt(data, field) {
    localStorage.setItem(lsname(field), data[field])
  }

  function lsname(name) {
    return "schooldays_" + name
  }
})(window)
