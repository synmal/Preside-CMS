/**
 * @presideService true
 * @singleton      true
 *
 */
component extends="AbstractHeartBeat" {

	/**
	 * @scheduledThreadpoolExecutor.inject presideScheduledThreadpoolExecutor
	 * @assetQueueService.inject           presidecms:dynamicservice:assetQueue
	 *
	 */
	public function init(
		  required any     scheduledThreadpoolExecutor
		, required any     assetQueueService
		,          numeric instanceNumber = 1
		,          string  threadName     = "Preside Asset Queue Processor #arguments.instanceNumber#"
	){
		super.init(
			  threadName                  = arguments.threadName
			, scheduledThreadpoolExecutor = arguments.scheduledThreadpoolExecutor
			, intervalInMs                = 2000
			, feature                     = "assetQueueHeartBeat"
		);

		_setAssetQueueService( arguments.assetQueueService );
		_setInstanceNumber( arguments.instanceNumber );

		return this;
	}

	// PUBLIC API METHODS
	public void function $run() {
		var queueService = _getAssetQueueService();

		try {
			queueService.processQueue();
		} catch( any e ) {
			$raiseError( e );
		}

		setLastRun();
	}

// GETTERS AND SETTERS
	private any function _getAssetQueueService() {
	    return _assetQueueService;
	}
	private void function _setAssetQueueService( required any assetQueueService ) {
	    _assetQueueService = arguments.assetQueueService;
	}

	private any function _getInstanceNumber() {
		return _instanceNumber;
	}
	private void function _setInstanceNumber( required any instanceNumber ) {
		_instanceNumber = arguments.instanceNumber;
	}
}