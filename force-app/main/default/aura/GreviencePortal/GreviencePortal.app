<aura:application access="GLOBAL" extends="ltng:outApp" implements="ltng:allowGuestAccess">
	<aura:dependency resource="GrevienceLWCCmp"/>
	<aura:handler name="init" value="{!this}" action="{!c.myAction}" />
</aura:application>