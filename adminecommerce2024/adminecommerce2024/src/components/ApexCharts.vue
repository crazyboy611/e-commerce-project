<template>
    <div>
      <!-- Render the ApexChart -->
      <apexchart
        :type="type"
        :options="options"
        :series="series"
        width="100%"
      />
    </div>
  </template>
  
  <script>
  export default {
    name: 'ApexChart',
    props: {
      type: {
        type: String,
        required: true,
      },
      options: {
        type: Object,
        required: true,
      },
      series: {
        type: Array,
        required: true,
      },
    },
    components: {
      apexchart: ApexCharts,
    },
  };
  </script>
  
  <style scoped>
  /* Add your component-specific styling here */
  </style>
  