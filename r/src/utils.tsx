export function filterNonNull<T>(ary: Array<null | T>): Array<T> {
  const res: Array<T> = []
  ary.forEach(x => x && res.push(x))
  return res
}
