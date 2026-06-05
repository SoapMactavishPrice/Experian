({
    init: function (component, event, helper) {
        var pageReference = component.get("v.pageReference"); var a = component.get("v.recordId");

        console.log('caller call ', pageReference);
        console.log('caller call ', JSON.parse(JSON.stringify(pageReference)));
        component.set("v.refRecordId", pageReference.state.c__refRecordId);
        component.set("v.sObjectName", pageReference.state.c__refsObjectName);

        // component.set("v.refRecordId", pageReference.state.refRecordId);
        // component.set("v.sObjectName", pageReference.state.refsObjectName);
    },
    reInit: function (component, event, helper) {
        console.log('This is fire');
        $A.get('e.force:refreshView').fire();
    }
})