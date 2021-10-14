<template>
  <div class="upload">
<input type="file" id="file" ref="file" v-on:change="handleFileUpload()"/>
    <input type="submit" @click="doUpload()">
  </div>
</template>

<script>
export default {
  data() {
      return {
          text: "",
          file: null
      }
  },          
  methods: {
 handleFileUpload(){
    this.file = this.$refs.file.files[0];
  },
      doUpload() {
          let bodyFormData = new FormData();
          bodyFormData.append('file', this.file);
          this.axios.post("/api/v1/upload_file", bodyFormData, {
              headers: { "Content-Type": "multipart/form-data", "Authorization": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpZCI6IjMiLCJleHAiOjE2MzQ4MTE5MDcsImlhdCI6MTYzNDIwNzEwN30.BHNo3BroGTxzrAYXP-5REnC-sf0MB3W7z6tPQo_sRMGUve5pv1G51mjzmg4H3bATYDMEdEwG1x9LLQUSmEy2GQ" }
          })
      }
  },
  mounted() {
      this.doUpload()
  }
}
</script>
