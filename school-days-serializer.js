// Load and save the flags from the elm program in localStorage.
// Loading is really careful to produce values that elm can use, so that it
// doesn't just blow up when we try to send it our values.
// An alternative might be to init without flags, and then use a Sub to push
// the saved data in?

(function(exports, storage) {
  'use strict';

  exports.saveSchoolDays = data => {
    console.log(data)
    saveInt(data, "finished")
    saveInt(data, "required")
    saveSkips(data)
  }

  exports.loadSchoolDays = () => {
    var data = {finished: 0, required: 180, skips: [], start: null}
    loadInt(data, "finished")
    loadInt(data, "required")
    loadSkips(data)
    return data
  }

  function loadSkips(data) {
    var stored = storage.getItem(lsname("skips"))
    if (stored == null) return
    var skips
    try {
      skips = JSON.parse(stored)
    } catch {
      return
    }
    if (!Array.isArray(skips)) return
    for (var skip of skips) {
      if (Array.isArray(skip) && Number.isInteger(skip[0]) && Number.isInteger(skip[1])) {
        data.skips.push([skip[0], skip[1]])
      }
    }
  }

  function saveSkips(data) {
    storage.setItem(lsname("skips"), JSON.stringify(data.skips))
  }

  function loadInt(data, field) {
    var stored = storage.getItem(lsname(field))
    var n = parseInt(stored)
    if (!isNaN(n)) {
      data[field] = n
    }
  }

  function saveInt(data, field) {
    storage.setItem(lsname(field), data[field])
  }

  function lsname(name) {
    return "schooldays_" + name
  }
})(window, localStorage)
