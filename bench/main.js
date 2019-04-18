const Tests = require('./bench_test.bs.js');

const median = function(p) {
  const size = p.length;

  if (size % 2 === 1) {
    return p[(size + 1) / 2];
  } else {
    const l = p[size / 2];
    const r = p[size / 2 + 1];

    return (l + r) / 2;
  }
}

const average = function(p) {
  return p.reduce(function(l, r) { return l + r; }) / p.length;
}

const inner0 = function(size, task) {
  const t1 = new Date();
  for (let s = 0; s < size; s++) {task();}
  const t2 = new Date();
  return [t2.getTime(), t1.getTime()];
}

const bench0 = function(interval, size, task) {
  const p = [];

  for (let i = 0; i < interval; i++) {
    const [t2, t1] = inner0(size, task);
    p.push(((t2 - t1) / size).toString());
  }

  return p
    .map(parseFloat)
    .sort(function(l, r) { return l - r; });
}

exports.median = median;
exports.average = average;
exports.inner0 = inner0;
exports.bench0 = bench0;
exports.Tests = Tests;

const opts = { };

const bench = function(name, task) {
  const {interval, size} = opts;
  const result = bench0(interval, size, task);
  const med = (median(result)).toString();
  const ave = (median(result)).toString();
  console.log(`${name}:\n  median:${med}\n  average:${ave}`);
};

const winston = require('winston');
const logger = winston.createLogger({
  transports: [new winston.transports.File({filename: "/dev/null"})],
  format: winston.format.combine(
      winston.format.label({label: "test"}),
      winston.format.timestamp(),
      winston.format.json()
  ),
  level: "debug"
});


const typ = process.argv[2]

opts.interval = 100;
opts.size = 100000;

switch (typ) {
  case "normal":
    bench("Log#normal", Tests.log_normal);
    break;
  case "raw":
    bench("Log#raw", function() {logger.log("info", { label: "hoge" })});
    break;
  case "uncurried":
    bench("Log#uncurried", Tests.log_fast);
    break;
}


// const bench = function(name, task) {
  // const result = bench0(size, interval, task);
  // // console.log(result);
  // const med = median(result);
  // const ave = average(result);

  // return [name, med, ave]
// };

// const main = [
    // bench("Task#log_normal", Tests.log_normal),
    // bench("Task#log_fast", Tests.log_fast)
  // ].map(function([name, median, average]){
    // console.log(`${name}:\n  median: ${median}\n  average: ${average}`)
  // });
