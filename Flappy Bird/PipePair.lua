--[[  
    PipePair Class  

    Used to represent a pair of pipes that scroll together,  
    with a random gap for the player to pass through.  
]]  

PipePair = Class{}

-- Define min and max values for the gap and spacing
local MIN_GAP = 90     -- Minimum vertical gap (harder)
local MAX_GAP = 140    -- Maximum vertical gap (easier)
local MIN_SPACING = 5 -- Minimum horizontal spacing to prevent overlap
local MAX_SPACING = 100 -- Maximum spacing for randomness

-- Variable to store the last pipe's position
local lastPipeX = 0  

function PipePair:init(y)
    -- Randomize the vertical gap height for this pipe pair
    self.GAP_HEIGHT = math.random(MIN_GAP, MAX_GAP)

    -- Flag to check if the pair has been scored
    self.scored = false

    -- Ensure the new pipe pair does not overlap the previous one
    local newPipeX = lastPipeX + math.random(MIN_SPACING, MAX_SPACING)

    -- If it's the first pipe, spawn it normally
    if lastPipeX == 0 then
        newPipeX = VIRTUAL_WIDTH + math.random(MIN_SPACING, MAX_SPACING)
    end

    self.x = newPipeX
    lastPipeX = self.x  -- Update last pipe's position

    -- Set Y-position for the upper pipe
    self.y = y

    -- Instantiate the upper and lower pipes with the randomized gap
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + self.GAP_HEIGHT)
    }

    -- Whether this pipe pair should be removed
    self.remove = false
end

function PipePair:update(dt)
    -- Move pipes to the left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for _, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
