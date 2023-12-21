// Generate Current Date and TIme
function getCurrentDateTime() {
    const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    const now = new Date();
    const day = now.getDate().toString().padStart(2, '0');
    const month = months[now.getMonth()];
    const year = now.getFullYear();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');

    const formattedDateTime = `${day}${month}${year} ${hours}:${minutes}:${seconds}`;
    return formattedDateTime;
}


function drawCharts() {
    fetch('/calculateIrrigation')
    .then(response => response.json())
    .then(data => {
        const gwIrrigationData = JSON.parse(data.crop_groundwater_irrigation_data_for_img);
        const gwLevelData = JSON.parse(data.groundwater_level_data_img);

        const CropIrrigationTitle = gwIrrigationData.irrigation.CropIrrigationTitle;
        const GroundWaterLeveltitle = gwLevelData.gw_level.GroundWaterLeveltitle;

        const years = gwIrrigationData.irrigation.Year.map(Number);
        const cornData = gwIrrigationData.irrigation.Corn ? gwIrrigationData.irrigation.Corn.map(Number): [];
        const wheatData = gwIrrigationData.irrigation.Wheat ? gwIrrigationData.irrigation.Wheat.map(Number): [];
        const soybeanData = gwIrrigationData.irrigation.Soybean ? gwIrrigationData.irrigation.Soybean.map(Number): [];
        const sgData = gwIrrigationData.irrigation.SG ? gwIrrigationData.irrigation.SG.map(Number): [];

        const netYears = gwLevelData.gw_level.Year.map(Number);
        const gwLevel = gwLevelData.gw_level.GW_level.map(Number); 
        const minAqLvl = gwLevelData.gw_level.Min_Aq.map(Number);
        const minPlus30 = gwLevelData.gw_level.MinPlus30.map(Number);

        // Create the first Highcharts for cropIrrigationChart

        Highcharts.chart('chart1', {
            title:{
                text: CropIrrigationTitle,
            },
            xAxis: {
                categories: years,
                title:{
                    text: '<b>Year since the beginning of the simulation</b>'
                },
            },
            yAxis: {
                title:{
                    text:'<b>Irrigation</b>',
                },
            },
            series: [
                { name: 'Corn', data: cornData, color: 'red'},
                { name: 'Wheat', data: wheatData, color: 'green'},
                { name: 'Soybean', data: soybeanData, color: 'blue'},
                { name: 'SG', data: sgData, color: 'orange'}
            ],

            exporting: {
                buttons:{
                    filename: `CropIrrigation_${getCurrentDateTime()}`,
                    contextButton:{
                        menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                    },
                },
            },
        });
        // Create the second Highcharts chart for energyNetIncomeCalculation
        Highcharts.chart('chart2', {
            title: {
                text: GroundWaterLeveltitle,
            },
            xAxis: {
                categories: netYears,
                title: {
                    text: '<b>Year since the beginning of the simulation</b>',
                },
            },
            yAxis: {
                title: {
                    text: '<b>GroundWater Level</b>',
                },
            },
            series: [
                { name: 'GW_level', data: gwLevel, color: 'red'},
                { name: 'Min_Aq', data: minAqLvl, color: 'green'},
                { name: 'MinPlus30', data: minPlus30, color: 'blue'}
            ],
            // Add exporting options
            exporting: {
                filename: `CropIrrigation_${getCurrentDateTime()}`,
                buttons:{
                    contextButton:{
                        menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                    },
                },
            },
        });


    })
    .catch(error =>{
        console.error('Error:',error)
    });
}

// Call the drawCharts function when the page loads
document.addEventListener('DOMContentLoaded', drawCharts);


