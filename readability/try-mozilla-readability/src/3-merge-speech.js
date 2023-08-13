const fs = require('fs')
const glob = require('glob')
const path = require('path')
const { dataDir } = require('./utils')
const child_process = require('child_process')

const targetFilesPath = path.join(dataDir, 'speech_ssml_all_targets.txt')
const destPath = path.join(dataDir, 'speech_ssml_all.mp3')

const main = async () => {
  const files = await glob.glob(path.join(dataDir, 'speech_ssml_*.mp3'))
  files.sort()

  fs.writeFileSync(targetFilesPath, files.map(file => `file '${file}'`).join('\n'))

  const proc = child_process.spawn('ffmpeg', [
    '-f',
    'concat',
    '-safe',
    '0',
    '-i',
    targetFilesPath,
    '-c',
    'copy',
    destPath,
  ])
  proc.stdout.on('data', data => console.log(data.toString()))
}

main()
  .then(() => console.log('Done'))
  .catch(console.error)
