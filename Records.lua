function WarpDeplete:GetRecordTableKey(level, affixes, name, order)
  keyParts = {level, name, order}
  for _, v in ipairs(affixes) do
    table.insert(keyParts, v)
  end
  bestTimeKey = table.concat(keyParts, ":")
  return bestTimeKey
end

-- orderNum is specified to accomodate for different kill orders
function WarpDeplete:GetRecordForObjective(level, affixes, name, order)
  bestTimeKey = self:GetRecordTableKey(level, affixes, name, order)
  return self.db.global.bestTimes[bestTimeKey]
end

function WarpDeplete:SetRecordForObjective(level, affixes, name, order, time)
  bestTimeKey = self:GetRecordTableKey(level, affixes, name, order)
  self.db.global.bestTimes[bestTimeKey] = time
end

function WarpDeplete:GetNumCompletedObjectives(objectives)
  local numCompleted = 0
  local stepCount = select(3, C_Scenario.GetStepInfo())
  for i = 1, stepCount - 1 do
    if objectives[i] and objectives[i].time then
      numCompleted = numCompleted + 1
    end
  end
  return numCompleted
end

function WarpDeplete:UpdateRecordForObjective(level, affixes, name, order, currentBestTime, time)
  local objectiveBestTime = self:GetRecordForObjective(
    level,
    affixes,
    name,
    order
  )
  if currentBestTime == nil or time < objectiveBestTime then
    self:PrintDebug(
      "Setting new best time for "
      .. level
      .. " "
      .. name
      .. ": "
      .. (objectiveBestTime or "nil")
      .. " --> "
      .. time
    )
    self:SetRecordForObjective(
      level,
      affixes,
      name,
      order,
      time
    )
    return objectiveBestTime
  else
    return nil
  end
end

function WarpDeplete:GetNumRecordsStored()
  local count = 0
  for _ in pairs(self.db.global.bestTimes) do count = count + 1 end
  return count
end
