<template>
  <div>
    <button id="add" class="button md-button" @click="publishAnnotation(annotation.id)" v-if="showButton">Publish</button>
    <div class="card card-content" v-bind:id="annotation.id" @click="videoSeek(annotation.timestamp)">
      <i class="fa fa-times-circle icon-button" @click="deleteAnnotation(annotation.id)" v-if="showButton"></i>
      <i class="fa fa-edit icon-button" @click="editAnnotation(annotation.id, annotation.content)" v-if="showButton"></i>
      <span class="timestamp">{{ new Date(annotation.timestamp * 1000).toISOString().substr(11, 8) }}</span>
      <div v-html="htmlContent" class="html-content"></div>
      <BibleModal v-if="bibleVerse" :bibleRef="bibleVerse"/>
    </div>
  </div>
</template>

<script>
import SimpleMDE from 'simplemde';
import BibleModal from './BibleModal.vue';

export default {
  name: 'Card',
  components: {
    BibleModal,
  },
  props: {
    annotation: Object,
  },
  data() {
    let htmlContent;
    let bibleVerse;
    return {
      htmlContent: SimpleMDE.prototype.markdown(this.annotation.content),
      bibleVerse,
      showButton : this.annotation.active && (this.annotation.timestamp != 0 && !this.annotation.timestamp)
    };
  },
  mounted() {
    vm.$refs.card = this;
  },
  methods: {
    deleteAnnotation(id) {
      this.$parent.$parent.$parent.deleteAnnotation(id);
    },
    editAnnotation(id, content) {
      this.$parent.$parent.$parent.loadForEdit(id, content);
    },
    openBibleModal(content) {
      this.bibleVerse = content;
    },
    closeBibleModal() {
      this.bibleVerse = '';
    },
    publishAnnotation(annotationId) {
      this.$parent.$parent.$parent.publishAnnotation(annotationId);
    },
    videoSeek(timestamp) {
        if (timestamp == '0' || timestamp) {
          if(this.$parent.player){
              this.$parent.player.seekTo(timestamp);
          } else if(this.$parent.$parent.$parent.player) {
            this.$parent.$parent.$parent.player.seekTo(timestamp);
          }
        }
    },
  },
};
</script>

<style scoped>
div.card {
  padding: 10px;
  background: #e0e5ec;
  margin: auto;
  width: 400px;
  border-radius: 2px;
  box-shadow:
  #e0e5ec 0px 0px 2px 2px,
  #a3b1c6 4px 4px 8px,
  #ffffff -4px -4px 8px;
  margin-bottom: 20px;
  cursor: grab;
}

.md-button {
  display: block;
  background-color:#E0E5EC;
  width:50px;
  height:30px;
  float: right;
  position: relative;
  margin-top: 0px;
}

.card-content {
  cursor: pointer;
}

.html-content {
  cursor: text;
  margin-top: -15px;
}

i.icon-button {
  float: right;
  margin-top: -5px;
  margin-left: 10px;
  cursor: pointer;
}

.timestamp {
  position: relative;
  color: grey;
  font-size: 0.7em;
  top: -10px;
  margin: -10px 0 -10px -5px
}

h1, h2, h3, h4, h5, h6 {
  margin: 3px 3px;
  margin-block-start: 0px;
  margin-block-end: 0px
}

p {
  margin-block-start: 0px;
    margin-block-end: 0px;
}
</style>
