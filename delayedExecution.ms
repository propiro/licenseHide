-- put me into startup folder
clearListener()
try (destroyDialog delayedExecutionDialog) catch()
curMaxVersion = ((maxversion())[1] / 1000)
print "Max version: " + curMaxVersion as string
-- various functions you might want to run at start of 3ds max
fn fn_hideLicence = -- hides licence owner name from 3ds max interface
(
qtMax = (python.import "qtmax")
(((((qtMax.GetQMaxMainWindow()).menuBar()).children())[2].children())[3]).setFixedHeight 0
	--messageBox "Licence Name should be hidden"
	--sleep (3)
	
)

fn fn_openLayerExplorer = -- opens layer explorer (preferably docked or tabbed to scene explorer)
(
macros.run "Scene Explorer" "SELayerExplorer"	
	
)

	
fn fn_displayStats = -- toggles displaying viewport statistics
(
	(
	struct view (id, tm)
	local prev = viewport.activeViewport

	with redraw off local views = for v = 1 to viewport.numViews collect
	(
		viewport.activeViewport = v
		actionMan.executeAction 0 "40829"  -- Tools: Show Statistics Toggle
		view id:v tm:(viewport.GetTM())
	)

	viewport.activeViewport = prev
	views
)	
	
		
)
	
	
	timerValUp = 0
Rollout delayedExecutionDialog "Delayed Exectution v0.01"
(

	
	label lbl1 "Delayed execution::" align:#center enabled:false
	label lbl2 "Executing in 5" align:#center enabled:false height:70
	timer clock20 "testClock" interval:1000 -- 1st-5th ticks delay, 6th tick execution, 7th-9th ticks exit delay, 10th tick exit and dialog destroy

-- 500ms means whole operation will take 500ms * 10 ticks = 5 seconds	
	
	
	on clock20 tick do
		(
		timerValUp = timerValUp+1
		case timerValUp of
			(
			1: ( lbl2.text = ("Executing in 5"))
			2: ( lbl2.text = ("Executing in 4"))
			3: ( lbl2.text = ("Executing in 3"))
			4: ( lbl2.text = ("Executing in 2"))
			5: ( lbl2.text = ("Executing in 1"))
			6: ( 
				lbl2.text = ("Executing commands:")
				lbl2.text = lbl2.text + "\nHiding licence owner UID."				
				fn_hideLicence()
				
				--fn_setStatistics()
				lbl2.text = lbl2.text + "\nToggling stats on all viewports."
				fn_displayStats()
				
				lbl2.text = lbl2.text + "\nEnabling Layer Explorer."
				fn_openLayerExplorer()
				
				)
			7: ( lbl2.text)
			8: ( lbl2.text = ("Commands Executed."))
			9: ( lbl2.text = ("Exiting."))
			10:((try (destroyDialog delayedExecutionDialog) catch() ))

				
			)	
		)
)
createDialog delayedExecutionDialog 200 100